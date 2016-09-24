class PostChangePasswordCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    password = @params[:password]
    if (password != @params[:confirm_password])
      @server.show_flash :error, "Passwords don't match."
      @server.redirect_to "/change-password"
      return
    end
    
    @server.user.change_password password
    @server.user.save!    
  
    @server.show_flash :notice, "Password changed."
    @server.redirect_to "/"
  end
end