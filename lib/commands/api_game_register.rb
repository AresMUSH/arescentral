class ApiGameRegisterCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    # A game with the same name, port, and host is surely the same game.
    game = Game.where(name: @params[:name], host: @params[:host], port: @params[:port]).first
    if (game)
      return { status: "success", data: { game_id: game.id.to_s, api_key: game.api_key } }.to_json
    end
    
    game = Game.new
    game.update_from @params
    if (!game.valid?)
      return { status: "failure", error: game.error_str }.to_json
    end
    game.last_ping = Time.now
    
    game.save!
    { status: "success", data: { game_id: game.id.to_s, api_key: game.api_key } }.to_json
  end
end


