class Game
  include Mongoid::Document
  
  def self.categories
    ["Historical", "Sci-Fi", "Fantasy", "Modern", "Supernatural", "Social", "Other"]
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
  field :is_open, :type => Boolean, :default => true
  
  has_many :linked_chars, :order => :name.asc
  
  validates_presence_of :name, :description, :category
  validates :category, inclusion: { in: Game.categories,
      message: "%{value} is not a valid category." }

  def update_from(params)
    self.name = params[:name]
    self.description = params[:description]
    self.host = params[:host]
    self.port = params[:port]
    self.category = params[:category]
    self.website = params[:website]
    self.public_game = params[:public_game]
  end
  
  def address
    self.website ? self.website : "telnet://#{host}:#{port}"
  end
  
  def status
    return "Closed" if !self.is_open
    return "Up" if (Time.now - self.last_ping) < 72.hours
    "Unknown"
  end
  
  def error_str
    str = ""
    errors.full_messages.each { |e| str << " #{e}. " }
    str
  end
  
  def is_public?
    public_game
  end
end