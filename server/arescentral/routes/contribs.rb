module AresCentral
  class ApiServer
    get '/plugins' do
      handle_request do 
        handler = PluginsIndexHandler.new(@user, params)
        handler.handle
      end
    end
    
    get '/plugin/:plugin_id' do
      handle_request do 
        handler = PluginDetailHandler.new(@user, params)
        handler.handle
      end
    end
  end
end