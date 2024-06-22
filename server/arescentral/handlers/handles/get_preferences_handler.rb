module AresCentral
  class GetPreferencesHandler
    
    def initialize(user)
      @user = user
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end
      
      {
        timezones: TimezoneHelper.timezones,
        preferences:
        {
          email: @user.email || "",
          security_question: @user.security_question || "",
          pose_autospace: @user.autospace || "",
          pose_quote_color: @user.quote_color || "",
          page_autospace: @user.page_autospace || "",
          page_color: @user.page_color || "",
          ascii_only: @user.ascii_only || false,
          screen_reader: @user.screen_reader || false,
          timezone: @user.timezone || "America/New_York",
          profile_image: @user.image_url || "",
          profile: @user.profile || ""
        } 
      }
      
    end
  end
end

    