module AresCentral
  class PluginsIndexHandler
    def initialize(user, params)
    end
    
    def handle      
      Plugin.all.to_a.sort_by { |p| p.name }.map { |p| p.summary_data }
    end
  end
end
