module AresCentral
  class LoginHandler
    
    def initialize(user, body_data)
      @user = user
      @name = body_data["name"] || ""
      @password = body_data["password"] || ""
    end
    
    def handle
      if (@user)
        raise InsufficientPermissionError.new
      end
      
      handle = Handle.find_by_name(@name)
      if (!handle)
        return { error: "That is not a valid username/password." }
      end
      
      if (handle.login_lockout_time && Time.now < handle.login_lockout_time)
        return { error: "Too many failed logins. Try back later." }
      end
        
      if (!handle.compare_password(@password))
        login_failures = handle.login_failures + 1
        if (login_failures > 5)
          login_failures = 0
          handle.update(login_lockout_time: Time.now + 60*60)
        end
        handle.update(login_failures: login_failures)
        
        return { error: "That is not a valid username/password." }
      end
        
      handle.update(login_failures: 0)
      handle.update(login_lockout_time: nil)
      handle.set_auth_token
      return Authorization.build_login_session(handle)
      
    end
  end
end

    