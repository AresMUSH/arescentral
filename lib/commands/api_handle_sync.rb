class ApiHandleSyncCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    [:game_id, :api_key, :handle_id, :char_name, :char_id].each do |param|
      return { status: "failure", error: "Missing #{param}." }.to_json if !@params[param]
    end
    
    handle = Handle.find(@params[:handle_id])
    if (!handle)
      return { status: "failure", error: "Handle not found." }.to_json
    end
    
    game = Game.find @params[:game_id]
    if (!game)
      return { status: "failure", error: "Game not found." }.to_json
    end
        
    if (game.api_key != @params[:api_key])
      return { status: "failure", error: "Invalid API key." }.to_json
    end
    
    char_name = @params[:char_name]
    char_id = @params[:char_id]
    
    linked_char = handle.linked_chars.select { |c| c.game == game && c.char_id == char_id }.first

    if (!linked_char)
      return { status: "success", data: { linked: false } }.to_json
    end
    
    linked_char.name = char_name
    linked_char.save!    
    
    data = {
      linked: true,
      autospace: handle.autospace, 
      page_autospace: handle.page_autospace,
      page_color: handle.page_color,
      timezone: handle.timezone,
      quote_color: handle.quote_color,
      friends: handle.friends.map { |f| f.name },
      ascii_only: handle.ascii_only,
      screen_reader: handle.screen_reader,
      profile: handle.profile
    }
    
    { status: "success", data: data }.to_json
  end
end


