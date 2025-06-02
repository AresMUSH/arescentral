module AresCentral
  class SavePreferencesHandler
    
    def initialize(user, body_data)
      @user = user
      @preferences = body_data["preferences"] || {}
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end      
      
      if (@user.id != @user.id)
        raise InsufficientPermissionError.new
      end
      
      if (@preferences["security_question"].blank?) 
        return { error: "Security question (favorite MU*) is required." }
      end
      
      if (!TimezoneHelper.timezones.include?(@preferences["timezone"]))
        return { error: "Invalid timezone." }
      end
            
      @user.update(
         {
           email: @preferences["email"],
           security_question: @preferences["security_question"],
           autospace: @preferences["pose_autospace"],
           quote_color: @preferences["pose_quote_color"],
           page_autospace: @preferences["page_autospace"],
           page_color: @preferences["page_color"],
           ascii_only: "#{@preferences['ascii_only']}".to_bool,
           screen_reader: "#{@preferences['screen_reader']}".to_bool,
           timezone: @preferences["timezone"],
           image_url: @preferences["profile_image"],
           profile: @preferences["profile"]
       })
         
      
      {}
      
    end
  end
end

    