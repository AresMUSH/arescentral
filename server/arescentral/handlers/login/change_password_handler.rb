module AresCentral
  class ChangePasswordHandler
    
    def initialize(user, body_data)
      @user = user
      @old_password = body_data["old_password"] || ""
      @new_password = body_data["new_password"] || ""
    end
    
    def handle
      if (!@user)
        raise InsufficientPermissionError.new
      end      
      
      if (@old_password == @new_password)
        return { error: "Old and new passwords can't be the same." }
      end
      
      if (!@user.compare_password(@old_password))
        return { error: "Old password doesn't match." }
      end
      
      error = Handle.check_password_requirements(@new_password)
      if (error) 
        return { error: error }
      end
      
      @user.change_password(@new_password)
        
      {}
    end
  end
end

    