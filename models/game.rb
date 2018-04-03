class Game
  include Mongoid::Document
  
  def self.categories
    ["Historical", "Sci-Fi", "Fantasy", "Modern", "Supernatural", "Social", "Other"]
  end
  
  def self.statuses
    [ 'In Development', 'Beta', 'Open', 'Closed', 'Sandbox' ]
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
  
  has_many :linked_chars, :order => :name.asc
  
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
  
  def is_open
    self.status != "Closed"
  end
  
  def address
    self.website ? self.website : "telnet://#{host}:#{port}"
  end
  
  def up_status
    return "Up" if (Time.now - self.last_ping) < 72.hours
    "Unknown"
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
end