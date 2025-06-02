module AresCentral
  class UpdateGameStatusHandler
        
    def initialize(user, params, body_data)
      @user = user
      @game_id = params["game_id"]
      @status = body_data["status"] || "In Development"
      @is_public = "#{body_data["is_public"]}".to_bool
      @wiki_archive = body_data["wiki_archive"]
    end
    
    def handle
      authorized = @user && @user.is_admin?
      if (!authorized)
        raise InsufficientPermissionError.new
      end
      
      game = Game[@game_id]
      if (!game)
        return { error: "Game not found." }
      end
      
      if (!Game.statuses.include?(@status))
        return { error: "Invalid status." }
      end
      
      AresCentral.logger.info "#{game.name} updated by #{@user.name}."
      
      game.update(status: @status)
      game.update(public_game: @is_public)
      game.update(wiki_archive: @wiki_archive)

      {}
    end
  end
end
