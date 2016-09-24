
class WebApp < Sinatra::Base
  get "/login" do
    if (@user)
      redirect to('/')
    else
      erb :'login/login', :layout => :default
    end
  end
  
  post "/login" do
    handler = PostLoginCmd.new(params, session, self, self.view_data)
    handler.handle      
  end

  get "/logout" do
    session.clear
    redirect to('/')
  end
  
  get "/forgot-password" do
    erb :'login/forgot-password', :layout => :default
  end
  
  post "/forgot-password" do
    handler = PostForgotPasswordCmd.new(params, session, self, self.view_data)
    handler.handle
  end
  
  get "/change-password", :auth => :user do
    erb :'login/change-password', :layout => :default
  end
  
  post "/change-password", :auth => :user do
    handler = PostChangePasswordCmd.new(params, session, self, self.view_data)
    handler.handle
  end
end