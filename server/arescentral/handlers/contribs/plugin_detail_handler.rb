module AresCentral
  class PluginDetailHandler
    def initialize(user, params)
      @id = params["plugin_id"]
    end
    
    def handle
      plugin = Plugin[@id]
      if (!plugin)
        raise NotFoundError.new
      end
      
      plugin.summary_data
    end
  end
end
