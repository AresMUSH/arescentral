class ApiHandleLinkCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    [:handle_name, :game_id, :link_code, :api_key, :char_name, :char_id].each do |param|
      return { status: "failure", error: "Missing #{param}." }.to_json if !@params[param]
    end
    
    handle = Handle.find_by_name(@params[:handle_name]).first
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
    
    code = @params[:link_code]
    if (!handle.link_codes.include?(code))
      return { status: "failure", error: "Invalid link code." }.to_json
    end
    
    char_name = @params[:char_name]
    char_id = @params[:char_id]
    
    if (handle.linked_chars.select { |c| c.game == game && c.char_id == char_id }.first)
      return { status: "failure", error: "That character is already linked." }.to_json
    end
    
    handle.link_codes.delete code
    handle.save!

    old_link = LinkedChar.where(char_id: char_id, game_id: game.id).first
    if (old_link)
      old_handle = old_link.handle
      old_handle.add_past_link(old_link)
      old_handle.save!
      old_link.destroy!
    end
    
    LinkedChar.create(name: char_name, game: game, handle: handle, char_id: char_id)
    
    
    { status: "success", data: { handle_id: handle.id.to_s, handle_name: handle.name } }.to_json
  end
end


