class ApiHandleUnlinkCmd
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
      return { status: "failure", error: "Character not linked to that handle." }.to_json
    end
    
    handle.add_past_link(linked_char)
    handle.save!
     
    linked_char.destroy!
    
    { status: "success", data: {} }.to_json
  end
end


