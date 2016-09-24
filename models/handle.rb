class Handle
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :name_upcase, :type => String
  field :autospace, :type => String, :default => "%r"
  field :timezone, :type => String, :default => "America/New_York"
  field :password_hash, :type => String
  field :profile, :type => String
  field :image_url, :type => String
  field :email, :type => String
  field :security_question, :type => String
  field :link_codes, :type => Array, :default => []

  field :password_entry, :type => String
  field :password_confirmation, :type => String
  
  has_many :linked_chars
  has_many :friendships
  
  before_validation :save_upcase_name
  
  validates_presence_of :name
  validates_presence_of :timezone
  validates_format_of :name, with: /\A[a-z0-9\-\_]+\z/i, message: "%{value} seems wrong"
  validates_uniqueness_of :email, if: 'email.present?'
  validates_uniqueness_of :name
  
  validate :validate_password_entry, on: :create
  
  def create_from(params)
    self.name = params[:name].capitalize
    self.password_entry = params[:password]
    self.password_confirmation = params[:confirm_password]
    self.email = params[:email]
    self.security_question = params[:security_question]
  end
  
  def update_from(params)
    self.autospace = params[:autospace]
    self.timezone = params[:timezone]
    self.image_url = params[:image_url]
    self.profile = params[:profile]
    self.email = params[:email]
    self.security_question = params[:security_question]
  end

  def friends
    friendships.map { |f| f.friend }
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
  
  def serializable_hash(options={})
    hash = super(options)
    hash[:id] = self.id.to_s
    hash
  end
  
  def self.find_by_name(name)
    Handle.where(name_upcase: name.upcase)
  end
  
  private
  def save_upcase_name
    self.name_upcase = self.name.nil? ? "" : self.name.upcase
  end
end