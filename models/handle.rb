class Handle
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :name_upcase, :type => String
  field :autospace, :type => String, :default => "%r"
  field :page_autospace, :type => String, :default => "%r"
  field :page_color, :type => String, :default => "%xg"
  field :quote_color, :type => String, :default => ""
  field :timezone, :type => String, :default => "America/New_York"
  field :password_hash, :type => String
  field :profile, :type => String
  field :image_url, :type => String
  field :email, :type => String
  field :security_question, :type => String
  field :screen_reader, :type => Boolean, :default => false
  field :link_codes, :type => Array, :default => []
  field :forum_banned, :type => Boolean, :default => false
  field :past_links, :type => Array, :default => []
  field :is_admin, :type => Boolean, :default => false
  field :ascii_only, :type => Boolean, :default => false
  field :last_ip

  attr_accessor :password_entry, :password_confirmation
  
  has_many :linked_chars
  has_many :past_chars
  has_many :friendships, class_name: Friendship, inverse_of: :owner
  has_many :friends_of, class_name: Friendship, inverse_of: :friend
  
  before_validation :save_upcase_name
  
  validates_presence_of :name
  validates_presence_of :timezone
  validates_format_of :name, with: /\A[A-Za-z0-9]+\z/, message: "%{value} must be at least two characters long, and contain only letters and numbers"
  validates_length_of :name, minimum: 2, maximum: 20
  validates_uniqueness_of :email, :allow_blank => true
  validates_uniqueness_of :name_upcase
  
  validate :validate_password_entry, on: :create
  
  def create_from(params)
    self.name = params[:name]
    self.password_entry = params[:password]
    self.password_confirmation = params[:confirm_password]
    self.email = params[:email]
    self.security_question = params[:security_question]
  end
  
  def update_from(params)
    self.autospace = params[:autospace]
    self.page_autospace = params[:page_autospace]
    self.page_color = params[:page_color]
    self.quote_color = params[:quote_color]
    self.timezone = params[:timezone]
    self.image_url = params[:image_url]
    self.profile = params[:profile]
    self.email = params[:email]
    self.security_question = params[:security_question]
    self.ascii_only = params[:ascii_only] == "on" ? true : false
    self.screen_reader = params[:screen_reader] == "on" ? true : false
  end

  def add_past_link(link)
    PastChar.create(name: link.name, handle: self, game: link.game)
  end
  
  def friends
    friendships.map { |f| f.friend }
  end
  
  def public_chars
    linked_chars.select { |c| c.public_char? }
  end
  
  def current_chars(viewer)
    self.linked_chars.select { |c| c.visible_to?(viewer) && c.game.is_open? }
  end
  
  def old_chars(viewer)
    list = self.linked_chars.select { |c| c.visible_to?(viewer) && !c.game.is_open? }
    list.concat self.past_chars.select { |c| c.visible_to?(viewer) }
  end
    
  def has_char_on_game?(game)
    return false if !game
    return true if self.linked_chars.any? { |h| h.game == game }
    self.past_chars.any? { |h| h.game == game }
  end
  
  def error_str
    str = ""
    errors.full_messages.each { |e| str << " #{e}. " }
    str
  end
  
  def validate_password_entry
    errors.add :password_entry, 'must be at least 6 characters' if (self.password_entry.length < 6)
    errors.add :password_entry, 'must match' if (self.password_entry != self.password_confirmation)
  end
      
  def change_password(raw_password)
    self.password_hash = hash_password(raw_password)
  end

  def compare_password(entered_password)
    hash = BCrypt::Password.new(self.password_hash)
    hash == entered_password
  end
  
  def hash_password(password)
    BCrypt::Password.create(password)
  end
  
  def reset_password
    temp_password = (0...8).map { (65 + rand(26)).chr }.join
    self.change_password temp_password
    temp_password
  end
  
  def serializable_hash(options={})
    hash = super(options)
    hash[:id] = self.id.to_s
    hash
  end
  
  def self.find_by_name(name)
    Handle.where(name_upcase: name.upcase)
  end
  
  def self.random_password
    (0...8).map { (65 + rand(26)).chr }.join
  end
  
  
  private
  def save_upcase_name
    self.name_upcase = self.name.nil? ? "" : self.name.upcase
  end
end