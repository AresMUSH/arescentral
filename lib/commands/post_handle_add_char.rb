class PostHandleAddCharCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle_id = @params[:handle_id]
    
    handle = HandleFinder.find(handle_id, @server)
    return if !handle
    return if !OwnerChecker.check(@server, handle)
    
    code = SecureRandom.uuid
    handle.link_codes << code
    handle.save!
    
    @server.show_flash :notice, "Your link code has been generated.  This code can only be used once.  Log in to your character on the game and run this command to link the character to your handle:  handle/link #{code}"
    @server.redirect_to "/handle/#{handle_id}/char/manage"
    
  end
end


