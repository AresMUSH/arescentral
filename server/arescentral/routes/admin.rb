module AresCentral
  class ApiServer

    get '/api/v2/admin/games' do
      handle_request do 
        handler = GamesAdminHandler.new(@user)
        handler.handle
      end
    end
    
    get '/api/v2/admin/stats' do
      handle_request do 
        handler = GamesStatsHandler.new(@user)
        handler.handle
      end
    end

    post '/api/v2/admin/ban/:handle_id' do
      handle_request do 
        handler = BanPlayerHandler.new(@user, params, true)
        handler.handle
      end
    end
    
    post '/api/v2/admin/un-ban/:handle_id' do
      handle_request do 
        handler = BanPlayerHandler.new(@user, params, false)
        handler.handle
      end
    end
    
    post '/api/v2/admin/reset-password/:handle_id' do
      handle_request do 
        handler = ResetPlayerPasswordHandler.new(@user, params)
        handler.handle
      end
    end
    
    post '/api/v2/admin/game-status/:game_id' do
      handle_request do 
        handler = UpdateGameStatusHandler.new(@user, params, self.get_request_body_json)
        handler.handle
      end
    end
    
    post '/api/v2/admin/plugin/create' do
      handle_request do 
        handler = PluginCreateHandler.new(@user, self.get_request_body_json)
        handler.handle
      end
    end
    
    post '/api/v2/admin/plugin/:plugin_id/update' do
      handle_request do 
        handler = PluginUpdateHandler.new(@user, params, self.get_request_body_json)
        handler.handle
      end
    end
    
  end
end