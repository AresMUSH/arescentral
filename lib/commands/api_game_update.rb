class ApiGameUpdateCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    game = Game.find(@params[:game_id])
    
    if (!game)
      return { status: "failure", error: "Game not found." }.to_json
    end
    
    if (game.api_key != @params[:api_key])
      return { status: "failure", error: "Invalid API key." }.to_json
    end
      
    game.update_from @params
    if (!game.valid?)
      return { status: "failure", error: game.error_str }.to_json
    end
    game.last_ping = Time.now
    
    game.save!
    { status: "success" }.to_json
  end
end


