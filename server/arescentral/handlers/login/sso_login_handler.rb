module AresCentral
  class SsoLoginHandler
    
    def initialize(body_data)
      @handle_name = body_data["name"]
      @pw = body_data["password"]
      @sso_request = body_data["sso_request"]
    end
    
    def handle
      
      handle = Handle.find_by_name(@handle_name)
      
      if (@sso_request.blank?)
        return { error: "Invalid SSO request." }
      end
      
      if (!handle)
        return { error: "Invalid username or password." }
      end
    
      if (handle.forum_banned)
        return { error: "Your forum privileges have been revoked. Contact the AresCentral admin if you believe this to be in error." }
      end
    
      if (handle.email.blank?)
        return { error: "The forum uses email registration, so you must have an email configured in your player handle settings. Go to 'My Account' on AresCentral to set one."}
      end
      
      if (!handle.compare_password(@pw))
        return { error: "Invalid username or password." }
      end
      
      secret = Secrets.forum_secret
      sso = SingleSignOn.parse(@sso_request, secret)
      sso.email = handle.email
      sso.name = handle.name
      sso.username = handle.name
      sso.require_activation = true
      sso.external_id = handle.id
      sso.bio = handle.profile
      sso.avatar_url = handle.image_url
      sso.sso_secret = secret

      { 
        redirect_url: sso.to_url("https://forum.aresmush.com/session/sso_login")
      }
    end
  end
end

    