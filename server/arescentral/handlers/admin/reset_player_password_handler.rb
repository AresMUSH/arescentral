module AresCentral
  class ResetPlayerPasswordHandler
        
    def initialize(user, params)
      @user = user
      @handle_id = params["handle_id"]
    end
    
    def handle
      authorized = @user && @user.is_admin?
      if (!authorized)
        raise InsufficientPermissionError.new
      end
      
      handle = Handle.find_by_name_or_id(@handle_id)
      if (!handle)
        return { error: "Handle not found." }
      end
      
      AresCentral.logger.info "#{handle.name} password reset by #{@user.name}."
      
      temp_password = handle.reset_password

      {
        password: temp_password
      }
    end
  end
end
