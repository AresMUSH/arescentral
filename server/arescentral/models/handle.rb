module AresCentral
  class Handle < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :name_upcase
    attribute :autospace, :default => "%r"
    attribute :page_autospace, :default => "%r"
    attribute :page_color, :default => "%xg"
    attribute :quote_color, :default => ""
    attribute :timezone, :default => "America/New_York"
    attribute :password_hash
    attribute :profile
    attribute :image_url
    attribute :email
    attribute :security_question
    attribute :screen_reader, :type => DataType::Boolean, :default => false
    attribute :link_codes, :type => DataType::Array, :default => []
    attribute :forum_banned, :type => DataType::Boolean, :default => false
    attribute :past_links, :type => DataType::Array, :default => []
    attribute :is_admin, :type => DataType::Boolean, :default => false
    attribute :ascii_only, :type => DataType::Boolean, :default => false
    attribute :last_ip
    attribute :old_id
    attribute :auth_token
    attribute :auth_token_expiry, :type => DataType::Time
    attribute :login_failures, :type => DataType::Integer, :default => 0
    attribute :login_lockout_time, :type => DataType::Time
    
    collection :linked_chars, "AresCentral::LinkedChar"
    collection :friendships, "AresCentral::Friendship", :owner
    collection :friends_of, "AresCentral::Friendship", :friend
       
    index :name_upcase
    
    before_save :save_upcase
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
  
    def self.find_by_name(name)
      Handle.find(name_upcase: name.upcase).first
    end
    
    # Note: Not to be used for API methods, which may still be using old IDs.
    def self.find_by_name_or_id(name_or_id)
      handle = Handle[name_or_id]
      return handle if handle
      return Handle.find_by_name(name_or_id)
    end
    
    def self.find_by_old_or_new_id(id)
      Handle.all.select { |g| "#{g.id}" == "#{id}" || "#{g.old_id}" == "#{id}" }.first
    end    
    
    def self.check_name_requirements(name)
      if (!name || name.length < 2)
        return "Handle must be at least two characters long."
      end
      
      if (name.length > 20)
        return "Handle must not be longer than 20 characters."
      end
      
      if (name !~ /\A[A-Za-z0-9]+\z/)
        return "Handle may contain only letters and numbers."
      end
      
      if (name =~ /^\d+$/)
        return "Handle cannot be only numbers."
      end
      
      return nil
      
    end
    
    def self.check_password_requirements(pw)
      if (!pw || pw.length < 8)
        return "Minimum password length: 8 characters."
      end
      if (pw.length > 24)
        return "Maximum password length: 24 characters."
      end
      if (pw =~ /^\d+$/)
        return "Password cannot be only numbers."
      end
      
      if (pw =~ /^\s+$/)
        return "Password must contain letters or numbers."
      end
      
      # Messes up the MU client commands
      if (pw.include?('='))
        return "Password cannot contain the = sign."
      end  
      
      return nil
    end
  
    def self.random_password
      (0...8).map { (65 + rand(26)).chr }.join
    end
    
    def self.random_link_code
      (0...8).map { (33 + rand(94)).chr }.join
    end 
    
    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
    # -----------------------------------
    # INSTANCE METHODS
    # -----------------------------------
    
    def compare_password(entered_password)
      hash = BCrypt::Password.new(self.password_hash)
      hash == entered_password
    end
    
    def change_password(raw_password)
      self.update(password_hash: Handle.hash_password(raw_password))
    end

    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
  
    def forum_id
      # Use old ID if available for backwards compat with old forum users
      self.old_id.blank? ? self.id : self.old_id
    end
    
    def friends
      self.friendships.map { |f| f.friend }
    end
    
    def is_friend?(friend)
      return false if !friend
      self.friendships.any? { |f| f.friend.id == friend.id }
    end
  
    def current_chars(viewer)
      self.linked_chars.select { |c| c.visible_to?(viewer) && !c.retired && c.game.is_open? }
    end
  
    def past_chars(viewer)
      self.linked_chars.select { |c| c.visible_to?(viewer) && ( !c.game.is_open? || c.retired ) }
    end
    
    def has_char_on_game?(game)
      return false if !game
      self.linked_chars.any? { |h| h.game == game }
    end
    
    def reset_password
      temp_password = (0...8).map { (65 + rand(26)).chr }.join
      self.change_password temp_password
      temp_password
    end
  
    def is_valid_auth_token?(token)
      return false if !token
      return false if !self.auth_token
      return false if !self.auth_token_expiry
      return self.auth_token == token && !self.auth_token_expired?
    end
    
    def auth_token_expired?
      return true if !self.auth_token
      return true if !self.auth_token_expiry
      self.auth_token_expiry < Time.now
    end
    
    def set_auth_token
      self.update(auth_token: "#{SecureRandom.uuid}")
      # 30 days, plus 8 hours so it doesn't expire during their prime-time
      self.update(auth_token_expiry: Time.now + (86400 * 30) + (60*60*8))
    end
    
    def is_admin?
      self.is_admin
    end
    
    def create_link(game, char_name, char_id)
    end
    
    
    def summary_data
      {
        name: self.name,
        id: self.id,
        image_url: self.image_url
      }       
    end
    
    def detail_data(viewer)
      data = self.summary_data
      data[:banned] = self.forum_banned
      data[:profile] = self.profile
            
      data[:current_chars] = self.game_character_data(self.current_chars(viewer))
      data[:past_chars] = self.game_character_data(self.past_chars(viewer))
      
      if (viewer && viewer.is_admin?)
        data[:last_ip] = self.last_ip
        data[:email] = self.email
        data[:security_question] = self.security_question
      end
      
      data
    end
    
    def game_character_data(links)
      links.group_by { |c| c. game }.map { |game, links|
        {
          game: {
            name: game.name,
            id: game.id
          },
          chars: links.uniq { |link| link.name }.map { |link| {
            name: link.name,
            id: link.id,
            replayed: game.is_replayed?(link.name, self.name),
            char_id: link.char_id
          }}          
        }
      }
    end
    
    def all_linked_chars_data(viewer)
      self.linked_chars.select { |link| !link.retired }.map { |link| {
        name: link.name,
        id: link.id,
        char_id: link.char_id,
        game: {
          name: link.game.name,
          id: link.game.id
        },
        temp_password: viewer == self ? link.temp_password : nil
      }}
    end
          
    def friends_data
      self.friendships.to_a.sort_by { |f| f.friend.name }.map { |f| {
          id: f.friend.id,
          name: f.friend.name,
          games: self.game_character_data(f.friend.current_chars(self))
        }}
    end
    
  end
end