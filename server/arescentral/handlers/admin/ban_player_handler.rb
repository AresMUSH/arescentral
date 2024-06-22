module AresCentral
  class BanPlayerHandler
        
    def initialize(user, params, ban_state)
      @user = user
      @handle_id = params["handle_id"]
      @ban_state = ban_state
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
      
      AresCentral.logger.info "#{handle.name} #{@ban_state ? 'banned' : 'un-banned'} by #{@user.name}."
      
      handle.update(forum_banned: @ban_state)

      {}
    end
  end
end
