class PostHandleCreateCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    if (!RecaptchaHelper.verify(@params["g-recaptcha-response"]))
      @server.show_flash :error, "Please prove you're human first."
      @server.redirect_to '/handle/create'
      return
    end
    
    handle = Handle.new
    handle.create_from(@params)
   
    if (!handle.valid?)      
      @server.show_flash :error, handle.error_str
      @server.redirect_to '/handle/create'
      return
    end

    @server.show_flash :notice, "Handle created!  You can now log in and go to 'My Account' to set your preferences."
    handle.change_password(@params[:password])
    handle.save!
    @server.redirect_to '/login'
  end
end
