class PostHandleEditCmd
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
    
    handle.update_from @params
    
    if (!handle.valid?)        
      @server.show_flash :error, handle.error_str
      @server.redirect_to "/handle/#{handle_id}/edit"
      return
    end
    
    @server.show_flash :notice, "Handle updated!"
    handle.save!
    @server.redirect_to '/'
    
  end
end


