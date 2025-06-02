module AresCentral
  class ApiServer
    
    # input: handle_name, char_name, char_id, game_id, api_key, link_code
    # output: handle_name, handle_id
    post "/api/handle/link" do
      handle_api do
        handler = ApiHandleLinkCmd.new(params)
        handler.handle    
      end
    end

    # output: profile markdown
    get "/api/handle/:handle_id/profile" do
      handle_api do
        handler = ApiHandleProfileCmd.new(params)
        handler.handle  
      end
    end
  
    # output: friends
    get "/api/handle/:handle_id/friends" do
      handle_api do
        handler = ApiHandleFriendsCmd.new(params)
        handler.handle  
      end
    end
  
    # input: game_id, api_key, char_id, char_name
    # output: autospace, timezone, quote_color, page_autospace, page_color, ascii_only, screen_reader
    post "/api/handle/:handle_id/sync" do
      handle_api do
        handler = ApiHandleSyncCmd.new(params)
        handler.handle  
      end
    end
  
    # input: game_id, api_key, char_id, char_name
    # output: nothing
    post "/api/handle/:handle_id/unlink" do
      handle_api do
        handler = ApiHandleUnlinkCmd.new(params)
        handler.handle  
      end
    end
  
    # input: game_id, api_key, char_id, password
    # output: matched
    post "/api/handle/:handle_id/reset_password" do
      handle_api do
        handler = ApiResetCharPasswordCmd.new(params)
        handler.handle  
      end
    end
  
    # input: name, host, port, category, website, description, public_game
    # output: api_key, game_id
    post "/api/game/register" do
      handle_api do
        handler = ApiGameRegisterCmd.new(params)
        handler.handle
      end
    end

    # input: api_key, name, host, port, category, website, description, public_game
    post "/api/game/:game_id/update" do
      handle_api do
        handler = ApiGameUpdateCmd.new(params)
        handler.handle
      end
    end
  
    # input: name
    post "/api/plugins/register" do
      handle_api do
        handler = ApiPluginRegisterCmd.new(params)
        handler.handle     
      end
    end  
  
    post "/api/plugins/create" do
      handle_api do
        handler = ApiPluginCreateCmd.new(params)
        handler.handle
      end
    end
  
    post "/api/test" do    
      handle_api do
        {}
      end
    end
  end
end
  