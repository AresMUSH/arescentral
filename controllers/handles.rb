class WebApp
  get "/handles" do
    @handles = Handle.all
    erb :"handles/index", :layout => :default
   end
  
  get "/handle/create" do
    erb :"handles/create", :layout => :default
  end
  
  get "/handle/:handle_name" do
    handler = GetHandleDetailCmd.new(params, session, self, @view_data)
    handler.handle
  end
  
  get "/handle/:handle_id/detail" do
    handler = GetHandleDetailCmd.new(params, session, self, @view_data)
    handler.handle
  end
 
  get "/handle/:handle_id/edit", :auth => :user do
    handler = GetHandleEditCmd.new(params, session, self, @view_data)
    handler.handle
 end
 
  post "/handle/:handle_id/edit", :auth => :user do
    handler = PostHandleEditCmd.new(params, session, self, @view_data)
    handler.handle
 end
 
 post "/handle/create" do
   handler = PostHandleCreateCmd.new(params, session, self, @view_data)
   handler.handle
 end
 
 get "/handle/:handle_id/friend/manage", :auth => :user do
   handler = GetHandleManageFriendCmd.new(params, session, self, @view_data)
   handler.handle
 end
 
 post "/handle/:handle_id/friend/add", :auth => :user do
   handler = PostHandleAddFriendCmd.new(params, session, self, @view_data)
   handler.handle
 end
 
 post "/handle/:handle_id/friend/delete", :auth => :user do
   handler = PostHandleDeleteFriendCmd.new(params, session, self, @view_data)
   handler.handle
 end
 
 get "/handle/:handle_id/char/manage", :auth => :user do
   handler = GetHandleManageCharCmd.new(params, session, self, @view_data)
   handler.handle
 end
 
 post "/handle/:handle_id/char/add", :auth => :user do
   handler = PostHandleAddCharCmd.new(params, session, self, @view_data)
   handler.handle
 end

 post "/handle/:handle_id/char/delete", :auth => :user do
   handler = PostHandleDeleteCharCmd.new(params, session, self, @view_data)
   handler.handle
 end
 
 post "/handle/:handle_id/char/reset_password", :auth => :user do
   handler = PostHandleCharResetPasswordCmd.new(params, session, self, @view_data)
   handler.handle
 end
end
