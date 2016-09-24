class GetGameDetailCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    game = Game.find(@params[:game_id])
    if (!game)
      @server.show_flash :error, "Game not found."
      @server.redirect_to "/games"
      return
    end
      
    @view_data[:game] = game
    @server.render_erb :"games/detail", :layout => :default
  end
end


