class ApiResetCharPasswordCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    [:handle_id, :game_id, :api_key, :char_id, :password].each do |param|
      return { status: "failure", error: "Missing #{param}." }.to_json if !@params[param]
    end
    
    handle = Handle.find @params[:handle_id]
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
    
    char_id = @params[:char_id]
    char = handle.linked_chars.select { |c| c.game == game && c.char_id == char_id }.first
    
    if (!char)
      return { status: "failure", error: "Character not found." }.to_json
    end
    
    matched = char.temp_password == @params[:password]
    if (matched)
      char.temp_password = nil
      char.save!
    end
    
    { status: "success", data: { matched: matched } }.to_json
  end
end


