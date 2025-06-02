module AresCentral
  class ResetLinkPasswordHandler
    
    def initialize(user, params)
      @user = user
      @link_id = params["link_id"]
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end      
      
      link = @user.linked_chars.select { |l| l.id == @link_id }.first
      if (!link)
        raise NotFoundError.new
      end
      
      temp_password = Handle.random_password
      link.update(temp_password: temp_password)
      
      { 
        links: @user.all_linked_chars_data(@user)
      }
    end
  end
end

    