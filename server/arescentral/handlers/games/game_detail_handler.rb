require 'benchmark'

module AresCentral
  class GameDetailHandler
        
    def initialize(user, params)
      @user = user
      @game_id = params[:game_id]
    end
    
    def handle
      game = Game[@game_id]
      if (!game)
        raise NotFoundError.new
      end
            
      if (!game.can_view_game?(@user))
        raise InsufficientPermissionError.new
      end
      
      game.detail_data
    end
    
  end
end
