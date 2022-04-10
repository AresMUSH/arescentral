class WebApp  
  
  # input: handle_name, char_name, char_id, game_id, api_key, link_code
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
  
  # input: game_id, api_key, char_id, char_name
  # output: autospace, timezone, quote_color, page_autospace, page_color, ascii_only, screen_reader
  post "/api/handle/:handle_id/sync" do
    handler = ApiHandleSyncCmd.new(params, session, self, @view_data)
    handler.handle  
  end
  
  # input: game_id, api_key, char_id, char_name
  # output: nothing
  post "/api/handle/:handle_id/unlink" do
    handler = ApiHandleUnlinkCmd.new(params, session, self, @view_data)
    handler.handle  
  end
  
  # input: game_id, api_key, char_id, password
  # output: matched
  post "/api/handle/:handle_id/reset_password" do
    handler = ApiResetCharPasswordCmd.new(params, session, self, @view_data)
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
  
  # input: name
  post "/api/plugins/register" do
    handler = ApiPluginRegisterCmd.new(params, session, self, @view_data)
    handler.handle     
  end

  #get "/api/games" do
  #  Game.all.to_json
  #end
  
  post "/api/resetpassword" do
    handle = HandleFinder.find_by_name(params[:name], self)
    password = handle.reset_password
    handle.save!
    password  
  end

  #post "/api/addplugin" do
  #  fara = HandleFinder.find_by_name("Faraday", self)
  #  clock = HandleFinder.find_by_name("Clockwork", self)
  #  tat = HandleFinder.find_by_name("Tat", self)
  #  Plugin.create(
  #  name: "Simple Innventory",
  #  key: "simpleinventory",
  #  description: "Simple inventory system.",
  #  url: "https://github.com/spiritlake/ares-simpleinventory-plugin",
  #  custom_code: "None",  # None / Minor / etc.
  #  web_portal: "Partial", # None / Partial / Full
  #  category: "Systems", # RP / Skills / Building / Community 
  #  installs: 0,
  #  handle: tat
  #  )  
  # end
  
  #post "/api/updateplugin" do
  #  plugin = Plugin.where(name: "Dice Roller").first
  #  plugin.category = "Systems"
  #  plugin.save!
  #  {}
  #  end
  
  #post "/api/updategame" do
    #game = Game.where(id: "11111").first
    #puts game.name
    #game.status = "Closed"
    #game.save!
    #end  
  
  post "/api/test" do
  end  
end