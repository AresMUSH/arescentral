module AresCentral
  class Plugin < Ohm::Model
    include ObjectModel

    def self.categories 
      [ "Skills", "Community", "RP", "Building" ]
    end
  
    def self.portal_support
      [ "Full", "Partial", "None" ]
    end
  
    def self.custom_code
      [ "Significant", "Moderate", "Minor", "None" ]
    end
    
    def self.url_to_key(url)
      if (url !~ /^https:\/\/github.com\/.+\/ares-[\w\d]+-plugin$/)
        return nil
      end
            
      url.split("/").last.gsub(/^ares-/, '').sub("-plugin", '').downcase
    end
  
    attribute :keyname
    attribute :name
    attribute :description
    attribute :url
    attribute :custom_code
    attribute :web_portal
    attribute :category
    attribute :installs, :type => DataType::Integer, :default => 0

    reference :handle, "AresCentral::Handle"

    def author_name
      self.handle ? self.handle.name : "Anonymous"
    end
    
    def install_count
      self.installs + Game.all.select { |g| g.uses_plugin?(self.keyname) }.count
    end
    
    def summary_data
      {
        id: self.id,
        key: self.keyname,
        name: self.name,
        description: self.description,
        url: self.url,
        custom_code: self.custom_code == "None" ? false : true,
        web_portal: self.web_portal == "None" ? false : true,
        category: self.category,
        installs: self.install_count,
        author_name: self.author_name,
        games: Game.all.select { |g| g.uses_plugin?(self.keyname) }.map { |g| {
          id: g.id,
          name: g.name
        }}
      }
    end
  end
end