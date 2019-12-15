class Game
  include Mongoid::Document
  
  def self.categories
    ["Historical", "Sci-Fi", "Fantasy", "Modern", "Supernatural", "Social", "Comic", "Other"]
  end
  
  def self.statuses
    [ 'In Development', 'Alpha', 'Beta', 'Open', 'Closed', 'Sandbox' ]
  end
  
  field :name, :type => String
  field :description, :type => String
  field :host, :type => String
  field :port, :type => Integer
  field :category, :type => String
  field :website, :type => String
  field :api_key, :type => String, :default => SecureRandom.uuid
  field :public_game, :type => Boolean, :default => false
  field :last_ping, :type => Time, :default => Time.now
  field :activity, :type => Hash, :default => {}
  field :status, :type => String
  field :wiki_archive, :type => String

  has_many :past_chars, :order => :name.asc
  has_many :linked_chars, :order => :name.asc
  
  before_destroy :delete_links
  
  validates_presence_of :name, :description, :category
  validates :category, inclusion: { in: Game.categories,
      message: "%{value} is not a valid category." }
  validates :status, inclusion: { in: Game.statuses, message: "%{value} is not a valid status." }

  def update_from(params)
    self.name = params[:name]
    self.description = params[:description]
    self.host = params[:host]
    self.port = params[:port]
    self.category = params[:category]
    self.website = params[:website]
    self.public_game = params[:public_game]
    self.status = params[:status] || "In Development"
    self.activity = JSON.parse(params[:activity])
  end
  
  def is_open?
    self.status != "Closed"
  end
  
  def activity_points
    points = 0
    self.activity.each do |day, times|
      times.each do |time, samples|
        total = samples.inject(:+)
        avg = (total / samples.count.to_f).round
        
        if (avg >= 5)
          points = points + 1
        end
      end
    end
    points
  end
  
  def activity_rating
    [(self.activity_points / 10.0).ceil, 4].min
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
    return "Up" if time_since_ping < 72.hours
    return "Down" if time_since_ping > 14.days
    "Unknown"
  end

  def can_view_game?(handle)
    return true if self.public_game
    return false if !handle
    return true if handle.is_admin
    return handle.has_char_on_game?(self)
  end
  
  def average_logins(day, time)
    day_samples = self.activity[day.to_s] || {}
    samples = day_samples[time.to_s] || [ 0 ]
                
    total = samples.inject(:+)
    (total / samples.count.to_f).round
  end
  
  def error_str
    str = ""
    errors.full_messages.each { |e| str << " #{e}. " }
    str
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
      c.handle.add_past_link(c)
      c.handle.save!
      c.destroy!
    end
  end
end