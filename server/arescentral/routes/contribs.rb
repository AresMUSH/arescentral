module AresCentral
  class ApiServer
    get '/api/v2/plugins' do
      handle_request do 
        handler = PluginsIndexHandler.new(@user, params)
        handler.handle
      end
    end
    
    get '/api/v2/plugin/:plugin_id' do
      handle_request do 
        handler = PluginDetailHandler.new(@user, params)
        handler.handle
      end
    end
  end
end