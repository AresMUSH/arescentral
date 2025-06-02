module AresCentral
  class GetLinkedCharsHandler
    
    def initialize(user)
      @user = user
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end      
        
      { 
        links: @user.all_linked_chars_data(@user),
        codes: @user.link_codes
      }
    end
  end
end

    