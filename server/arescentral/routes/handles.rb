module AresCentral
  class ApiServer

    get '/handles' do
      handle_request do 
        handler = HandlesIndexHandler.new(@user, params)
        handler.handle
      end
    end

    get '/handle/:handle_id' do
      handle_request do 
        handler = HandleDetailHandler.new(@user, params)
        handler.handle
      end
    end
    
    get '/preferences' do
      handle_request do 
        handler = GetPreferencesHandler.new(@user)
        handler.handle
      end
    end
    
    post '/preferences' do
      handle_request do 
        handler = SavePreferencesHandler.new(@user, self.get_request_body_json)
        handler.handle
      end
    end
    
    get '/friends' do
      handle_request do 
        handler = GetFriendsHandler.new(@user)
        handler.handle
      end
    end

    post '/friend/:friend_id/remove' do
      handle_request do 
        handler = RemoveFriendHandler.new(@user, params)
        handler.handle
      end
    end

    post '/friend/:friend_id/add' do
      handle_request do 
        handler = AddFriendHandler.new(@user, params)
        handler.handle
      end
    end
    
    get '/links' do
      handle_request do 
        handler = GetLinkedCharsHandler.new(@user)
        handler.handle
      end
    end
    
    post '/links/code' do
      handle_request do 
        handler = GenerateLinkCodeHandler.new(@user)
        handler.handle
      end
    end
    
    post '/link/:link_id/reset-password' do
      handle_request do 
        handler = ResetLinkPasswordHandler.new(@user, params)
        handler.handle
      end
    end
    
    post '/link/:link_id/unlink' do
      handle_request do 
        handler = UnlinkCharHandler.new(@user, params)
        handler.handle
      end
    end
    
  end
end