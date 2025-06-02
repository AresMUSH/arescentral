module AresCentral
  class TokenVerifyHandler
    
    def initialize(body_data)
      @id = body_data["id"] || ""
      @token = body_data["token"] || ""
    end
    
    def handle
      handle = Handle[@id]
      if (!handle)
        return { error: "Couldn't authenticate - id not found." }
      end
      
      if (!handle.is_valid_auth_token?(@token))
        return { error: "Invalid authentication." }
      end
              
      return Authorization.build_login_session(handle)
      
    end
  end
end

    