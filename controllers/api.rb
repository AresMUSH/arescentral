class WebApp  
  
  # input: handle_name, char_name, char_id, game_id, link_code
  # output: handle_name, handle_id
  post "/api/handle/link" do
    handler = ApiHandleLinkCmd.new(params, session, self, @view_data)
    handler.handle    
  end

  # output: profile markdown
  get "/api/handle/:handle_id/profile" do
    handler = ApiHandleProfileCmd.new(params, session, self, @view_data)
    handler.handle  
  end
  
  # output: friends
  get "/api/handle/:handle_id/friends" do
    handler = ApiHandleFriendsCmd.new(params, session, self, @view_data)
    handler.handle  
  end
  
  # input: game_id, char_id, char_name
  # output: autospace, timezone, 
  post "/api/handle/:handle_id/sync" do
    handler = ApiHandleSyncCmd.new(params, session, self, @view_data)
    handler.handle  
  end
  
  # input: name, host, port, category, website, description, public_game
  # output: api_key, game_id
  post "/api/game/register" do
    handler = ApiGameRegisterCmd.new(params, session, self, @view_data)
    handler.handle
  end

  # input: api_key, name, host, port, category, website, description, public_game
  post "/api/game/:game_id/update" do
    handler = ApiGameUpdateCmd.new(params, session, self, @view_data)
    handler.handle
  end
  
  post "/api/test" do
  end  
end