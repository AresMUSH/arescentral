module AresCentral
  class ApiServer
    
    
    post '/api/v2/register' do
      handle_request do 
        handler = RegisterHandler.new(@user, @ip_addr, self.get_request_body_json)
        handler.handle
      end
    end    

    post '/api/v2/login' do
      handle_request do 
        handler = LoginHandler.new(@user, self.get_request_body_json)
        handler.handle
      end
    end   
    

    post '/api/v2/forgot-password' do
      handle_request do 
        handler = ForgotPasswordHandler.new(self.get_request_body_json)
        handler.handle
      end
    end   
    
    post '/api/v2/change-password' do
      handle_request do 
        handler = ChangePasswordHandler.new(@user, self.get_request_body_json)
        handler.handle
      end
    end    
    
    post '/api/v2/token/verify' do
      handle_request do 
        handler = TokenVerifyHandler.new(self.get_request_body_json)
        handler.handle
      end
    end    
    
    post "/api/v2/sso/login" do
      handle_request do       
        handler = SsoLoginHandler.new(self.get_request_body_json)
        handler.handle
      end
    end
    
  end
end