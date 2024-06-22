module AresCentral
  class ApiServer
    
    
    post '/register' do
      handle_request do 
        handler = RegisterHandler.new(@user, @ip_addr, self.get_request_body_json)
        handler.handle
      end
    end    

    post '/login' do
      handle_request do 
        handler = LoginHandler.new(@user, self.get_request_body_json)
        handler.handle
      end
    end   
    

    post '/forgot-password' do
      handle_request do 
        handler = ForgotPasswordHandler.new(self.get_request_body_json)
        handler.handle
      end
    end   
    
    post '/change-password' do
      handle_request do 
        handler = ChangePasswordHandler.new(@user, self.get_request_body_json)
        handler.handle
      end
    end    
    
    post '/token/verify' do
      handle_request do 
        handler = TokenVerifyHandler.new(self.get_request_body_json)
        handler.handle
      end
    end    
    
    post "/sso/login" do
      handle_request do       
        handler = SsoLoginHandler.new(self.get_request_body_json)
        handler.handle
      end
    end
    
  end
end