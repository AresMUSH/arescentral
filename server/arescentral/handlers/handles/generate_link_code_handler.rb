module AresCentral
  class GenerateLinkCodeHandler
    
    def initialize(user)
      @user = user
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end      
      
      codes = @user.link_codes || []
      if (codes.count >= 5)
        return { error: "Please use one of your existing codes." }
      end
      
      code = SecureRandom.uuid
      codes << code
      @user.update(link_codes: codes)
      
      { 
        codes: codes
      }
    end
  end
end

    