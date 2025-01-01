module AresCentral
  class Game < Ohm::Model
    include ObjectModel
    
    def self.categories
      ["Historical", "Sci-Fi", "Fantasy", "Modern", "Supernatural", "Social", "Comic", "Other"]
    end
  
    def self.statuses
      [ 'In Development', 'Alpha', 'Beta', 'Open', 'Closed', 'Sandbox' ]
    end
  
    attribute :name
    attribute :description
    attribute :host
    attribute :port, :type => DataType::Integer
    attribute :category
    attribute :website
    attribute :api_key, :default => SecureRandom.uuid
    attribute :public_game, :type => DataType::Boolean, :default => false
    attribute :last_ping, :type => DataType::Time, :default => Time.now
    attribute :activity, :type => DataType::Hash, :default => {}
    attribute :extras, :type => DataType::Array, :default => []
    attribute :status
    attribute :wiki_archive
    attribute :old_id
    attribute :last_status_update, :type => DataType::Time, :default => Time.now

    collection :linked_chars, "AresCentral::LinkedChar"
  
    before_delete :delete_links
  
    def self.find_by_old_or_new_id(id)
      Game.all.select { |g| "#{g.id}" == "#{id}" || "#{g.old_id}" == "#{id}" }.first
    end
    
    def is_closed?
      self.status == "Closed" || self.up_status == "Lost"
    end
    
    def is_open?
      self.status != "Closed" && self.status != "In Development" && self.up_status != "Lost"
    end
  
    def is_in_dev?
      self.status == "In Development" && self.up_status != "Lost"
    end
  
    def is_active?
      self.status != "Closed" && self.up_status == "Up" && 
      (self.is_recently_updated || self.activity_rating >= 2)
    end
    
    def activity_points
      points = 0
      self.activity.each do |day, times|
        times.each do |time, samples|
          total = samples.inject(:+)
          avg = (total / samples.count.to_f).round
        
          if (avg >= 10)
            points = points + 2
          elsif (avg >= 5)
            points = points + 1
          elsif (avg > 0)
            points = points + 0.25
          end
        end
      end
      points
    end
  
    def activity_rating
      if (self.activity_points >= 70)
        return 5
      elsif (self.activity_points >= 50)
        return 4
      elsif (self.activity_points >= 30)
        return 3
      elsif (self.activity_points >= 15)
        return 2
      elsif (self.activity_points > 0)
        return 1
      else
        return 0
      end
    end
  
    def address
      if (self.website.blank?)
        "http://#{host}"
      else
        if (self.website.start_with?("http"))
          self.website
        else
          "http://#{self.website}"
        end
      end
    end
  
    def up_status
      time_since_ping = (Time.now - self.last_ping)
      return "Up" if time_since_ping < (36 * 3600)
      return "Lost" if time_since_ping > (86400 * 90) # 90 days
      "Down"
    end

    # Only used for admin reporting
    def report_status
      return "open" if self.is_public? && self.is_open?
      return "dev" if self.is_public? && self.is_in_dev? 
      return "private" if !self.public_game && self.up_status == "Up"
      return "closed"
    end
  
    def can_view_game?(handle)
      return true if self.public_game
      return false if !handle
      return true if handle.is_admin
      return handle.has_char_on_game?(self)
    end
  
    def average_logins(day, time)
      day_samples = (self.activity || {})[day.to_s] || {}
      samples = day_samples[time.to_s] || [ 0 ]

      total = samples.inject(:+)
      (total / samples.count.to_f).round
    end
  
    def is_public?
      public_game
    end
  
    def self.activity_days
      [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ]
    end
  
    def self.activity_times
      [ '12-3am', '4-7am', '8-11am', '12-3pm', '4-7pm', '8-11pm']
    end
  
    def delete_links
      self.linked_chars.each do |c|
        c.delete
      end
    end   
    
    def create_or_update_linked_char(char_name, char_id, handle)
      new_link = nil
      
      self.linked_chars.select { |link| link.name == char_name }
        .each do |link|
          if (link.handle == handle)
            # Old char played by same player - ressurected
            AresCentral.logger.info "Updating existing link: #{char_name}@#{self.name} by #{handle.name}."
            link.update(retired: false)
                        
            new_link = link
          else
            # Old char played by someone else, taken over
            AresCentral.logger.info "Link retired: #{char_name}@#{self.name} by #{handle.name}."
            link.update(retired: true)
          end
          
          if (!char_id.blank?)
            AresCentral.logger.info "Link #{link.id} updating char id from #{link.char_id} to #{char_id}."            
            link.update(char_id: char_id)
          end
      end
    
      if (!new_link)
        AresCentral.logger.info "New link: #{char_name}@#{self.name} by #{handle.name}."        
        new_link = LinkedChar.create(name: char_name, game: self, handle: handle, char_id: char_id)
      end
      new_link
    end
    
    # NOTE! This reflects an activity 'star' rating where each star = 5 players
    def average_activity_table
      activity_table = {}
      Game.activity_days.each_with_index do |day, day_index|
        activity_table[day] = {}
        Game.activity_times.each_with_index do |time, time_index|
          avg = self.average_logins(day_index, time_index)
          stars = (avg / 5.0)
          activity_table[day][time] = stars
        end
      end
      activity_table
    end
    
    def is_recently_updated
      last_updated = self.last_status_update || self.created_at
      Time.now - last_updated < (30 * 86400)
    end
            
    def is_replayed?(name, handle_name)
      self.linked_chars.any? { |a| (a.name == name) && (a.handle.name != handle_name) }
    end
    
    def current_chars
      self.linked_chars.select { |c| !c.retired }
    end
    
    def past_chars
      self.linked_chars.select { |c| c.retired }
    end
    
    # Builds a list of all replayed chars - faster than checking is_replayed? over and over for every player.
    def all_replayed_chars
      self.linked_chars
         .group_by { |c| c.name }
         .select { |char_name, links|  links.map { |l| l.handle.name }.uniq.count > 1 }
    end
    
    def debug_replayed_chars_report
      self.all_replayed_chars.map { |char_name, links| "#{char_name}: #{links.map { |l| l.handle.name }}" }
    end
    
    def uses_plugin?(name)
      (self.extras || []).include?(name.downcase)
    end
    
    def summary_data
      {
        id: self.id,
        name: self.name,
        is_open: self.is_open?,
        description: self.description,
        host: self.host,
        port: self.port,
        category: self.category,
        website: self.address,
        public_game: self.public_game,
        last_ping: self.last_ping ? self.last_ping.strftime('%m/%d/%Y') : "",
        status: self.status,
        up_status: self.up_status,
        wiki_archive: self.wiki_archive,
        activity_rating: self.activity_rating,
        activity_points: self.activity_points,
        recently_updated: self.is_recently_updated,
        is_active: self.is_active?,
        extras: self.extras || [],
        summary: self.description.length > 150 ? "#{self.description[0..150]}..." : self.description
      }
    end 
    
    def detail_data
      data = self.summary_data
      
      data[:activity_table] = self.average_activity_table
      data[:activity_day_titles] = Game.activity_days
      data[:activity_time_titles] = Game.activity_times
      data[:created_at] = self.created_at
      
      replayed = self.all_replayed_chars
      
      current = self.linked_char_data(self.current_chars, replayed)
      past = self.linked_char_data(self.past_chars, replayed)      
      
      data[:current_chars] = current
      data[:past_chars] = past
      
      data
    end
    
    def linked_char_data(links, replayed)
      links.group_by { |c| c.handle }.sort_by { |h, c| h.name }.map { |handle, chars|
        {
          handle: {
            name: handle.name,
            id: handle.id 
          },
          chars: chars.uniq { |c| c.name }.sort_by { |c| c.name }.map { |c| {
            name: c.name,
            replayed: replayed.include?(c.name),
            id: c.id,
            char_id: c.char_id
          }}
        }
      }
    end
  end
end