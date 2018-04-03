class PostDeleteGameCmd
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
    @server.show_flash :info, "Deleted #{game.name}."
    game.destroy
    @server.redirect_to '/games'
  end
end