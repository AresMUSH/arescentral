class Plugin
  include Mongoid::Document
  
  def self.categories 
    [ "Skills", "Community", "RP", "Building" ]
  end
  
  def self.portal_support
    [ "Full", "Partial", "None" ]
  end
  
  def self.custom_code
    [ "Significant", "Moderate", "Minor", "None" ]
  end
  
  field :key, :type => String
  field :name, :type => String
  field :description, :type => String
  field :url, :type => String
  field :custom_code, :type => String
  field :web_portal, :type => String
  field :category, :type => String
  field :installs, :type => Integer, :default => 0

  belongs_to :handle

  def author_name
    self.handle ? self.handle.name : "Anonymous"
  end
  
  def update_from(params)
    self.key = params[:key]
    self.name = params[:name]
    self.description = params[:description]
    self.url = params[:url]
    self.custom_code = params[:custom_code]
    self.web_portal = params[:web_portal]
    self.category = params[:category]
    # Installs is not updated this way
  end
end