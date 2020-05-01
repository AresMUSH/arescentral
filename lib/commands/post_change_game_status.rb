class PostChangeGameStatusCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    return if !AdminChecker.check(@server)
    
    game = Game.find(@params[:game_id])
    if (!game)
      @server.show_flash :error, "Game not found."
      @server.redirect_to '/games'
    end
    
    status = @params[:status]
        
    case status
    when "Destroy"
      game.destroy
    when "Close"
      game.status = "Closed"
      game.save!
    when "Private"
      game.public_game = false
      game.save!
    else
      @server.show_flash :error, "Invalid status."
      @server.redirect_to '/games'
    end
    
    @server.show_flash :info, "#{game.name} status changed: #{status}."
    @server.redirect_to '/games'
  end
end