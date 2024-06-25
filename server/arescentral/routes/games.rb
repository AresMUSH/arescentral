module AresCentral
  class ApiServer
    
    get '/api/v2/games' do      
      handle_request do 
        handler = GamesIndexHandler.new(@user)
        handler.handle
      end
    end
    
    get '/api/v2/game/:game_id' do
      handle_request do       
        handler = GameDetailHandler.new(@user, params)
        handler.handle
      end
    end
    
    get '/api/v2/games/admin' do
      handle_request do 
        handler = GamesAdminHandler.new(@user)
        handler.handle
      end
    end
    
    get '/api/v2/games/stats' do
      handle_request do 
        handler = GamesStatsHandler.new(@user)
        handler.handle
      end
    end
    
    post '/api/v2/log/clean' do
      handle_request do 
        handler = LogCleanerHandler.new(self.get_request_body_json)
        handler.handle
      end
    end
    
  end
end