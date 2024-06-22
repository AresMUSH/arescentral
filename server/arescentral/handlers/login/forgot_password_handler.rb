module AresCentral
  class ForgotPasswordHandler
    
    def initialize(body_data)
      @email = body_data["email"] || ""
      @name = body_data["name"] || ""
    end
    
    def handle
      # All returns have no data to prevent account fishing
      return {} if @email.blank? || @name.blank?
      
      handle = Handle.find_by_name(@name)
      if (!handle)
        AresCentral.logger.info "Reset password request for #{@name} - not found."
        return {}
      end
      
      if (handle.email != @email)
        AresCentral.logger.info "Reset password request for #{@name} - email doesn't match."
        return {}
      end
      
      temp_password = handle.reset_password
      message = "Your password has been reset to: #{temp_password}.  Please log in and reset it."

      AresCentral.logger.info "Rest password for #{@email} - #{handle.name}."
  
      Mailer.send(handle.email, "AresCentral Password Reset", message)
      {}
    end
  end
end

    