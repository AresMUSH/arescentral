class PostHandleDeleteCharCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle_id = @params[:handle_id]
    char_id = @params[:char_id]
    
    handle = HandleFinder.find(handle_id, @server)
    return if !handle
    return if !OwnerChecker.check(@server, handle)
        
    char = handle.linked_chars.select { |c| c.id.to_s == char_id }.first
    if (!char)
       @server.show_flash :error, "That character is not linked to your handle."
       @server.redirect_to "/handle/#{handle_id}/edit"
       return
     end
     
    char.destroy!
    
    @server.show_flash :notice, "Character unlinked."
    @server.redirect_to "/handle/#{handle_id}/edit"    
  end
end


