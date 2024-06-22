module AresCentral
  class RegisterHandler
    
    def initialize(user, ip_addr, body_data)
      @user = user
      @ip_addr = ip_addr
      @name = body_data["name"] || ""
      @password = body_data["password"] || ""
      @email = body_data["email"]
      @security_question = body_data["security_question"]
      @captcha = body_data["captcha"]
    end
    
    def handle
      if (@user)
        raise InsufficientPermissionError.new
      end
            
      if (!TurnstileHelper.verify(@captcha))
        return { error: "Captcha verification failed. If you're not a bot, please try again in a bit." }
      end    
    
      error = Handle.check_name_requirements(@name)
      if (error)
        return { error: error }
      end
      
      error = Handle.check_password_requirements(@password)
      if (error)
        return { error: error }
      end
            
      handle = Handle.find_by_name(@name)
      if (handle)
        return { error: "Handle already exists." }
      end
                        
      handle = Handle.create(name: @name, email: @email, security_question: @security_question, last_ip: @ip_addr)
      if (!handle)
        raise "Trouble creating handle."
      end

      if (@security_question.blank?) 
        return { error: "Security question (favorite MU*) is required." }
      end

      handle.change_password(@password)
      handle.set_auth_token
      return Authorization.build_login_session(handle)
    end
  end
end

    