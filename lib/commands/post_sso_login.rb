class PostSsoLoginCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    user = @params[:handle]
    pw = @params[:password]
    
    handle = Handle.where(name_upcase: user.upcase).first
    if (handle && handle.compare_password(pw))

      if (handle.email.blank?)
        @server.show_flash :error, "You must set an email on your handle account to access the forums.  The forum uses email registration to prevent spam.  Log in and go to 'My Account' if you want to set up an email."
        @server.redirect_to "/"
        return
      end
      
      if (handle.forum_banned)
        @server.show_flash :error, "Your forum privileges have been revoked.  Contact the AresCentral admin if you believe that to be a mistake."
        @server.redirect_to "/"
        return
      end
      
      secret = Config.forum_secret
      sso = SingleSignOn.parse(@session['sso'], secret)
      sso.email = handle.email
      sso.name = handle.name
      sso.username = handle.name
      sso.require_activation = true
      sso.external_id = handle.id
      sso.bio = handle.profile
      sso.avatar_url = handle.image_url
      sso.sso_secret = secret

      @server.redirect_to sso.to_url("https://forum.aresmush.com/session/sso_login")

    end

    @server.show_flash :error, "Invalid handle name or password."
    @server.redirect_to "/sso?#{@session['sso']}"
  end
end