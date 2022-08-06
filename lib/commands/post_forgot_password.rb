class PostForgotPasswordCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle = Handle.where(email: @params[:email]).first
    
    if (handle)
      temp_password = Handle.random_password
      message = "Your password has been reset to: #{temp_password}.  Please log in and reset it."
    
      handle.change_password(temp_password)
      handle.save!
    
      MailHelper.send(handle.email, "AresCentral Password Reset", message)
    end
  
    @server.show_flash :notice, "If that email is in our records, a new password will be sent to it."
    @server.redirect_to "/"
  end
end