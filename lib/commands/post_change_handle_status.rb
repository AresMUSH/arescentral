class PostChangeHandleStatus
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    return if !AdminChecker.check(@server)
    
    handle = HandleFinder.find(@params[:handle_id], @server)
    if (!handle)
      @server.show_flash :error, "Handle not found."
      @server.redirect_to '/handles'
    end
    
    status = @params[:status]
        
    case status
    when "Ban"
      handle.forum_banned = true
      handle.save!
      @server.show_flash :info, "#{handle.name} banned."
    when "ResetPw"
      temp_password = Handle.random_password
      handle.change_password(temp_password)
      handle.save!
      @server.show_flash :info, "Password reset to: #{temp_password}"
      
    else
      @server.show_flash :error, "Invalid status."
      @server.redirect_to '/handles'
    end
    
    @server.redirect_to '/handles'
  end
end