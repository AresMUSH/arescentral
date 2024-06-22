module AresCentral
  class ApiServer
    
    get '/games' do      
      handle_request do 
        handler = GamesIndexHandler.new(@user)
        handler.handle
      end
    end
    
    get '/game/:game_id' do
      handle_request do       
        handler = GameDetailHandler.new(@user, params)
        handler.handle
      end
    end
    
    get '/games/admin' do
      handle_request do 
        handler = GamesAdminHandler.new(@user)
        handler.handle
      end
    end
    
    get '/games/stats' do
      handle_request do 
        handler = GamesStatsHandler.new(@user)
        handler.handle
      end
    end
    
  end
end