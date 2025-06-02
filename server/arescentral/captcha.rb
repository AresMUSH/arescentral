module AresCentral
  module RecaptchaHelper
    
    def self.verify(token)

      url = "https://www.google.com/recaptcha/api/siteverify"
      body = {
        secret: Secrets.recaptcha_secret,
        response: token        
      }
            
      connector = HttpConnector.new
      response = connector.post(url, body)
            
      data = JSON.parse(response.body)
      data["success"]
    end
  end
  
  module TurnstileHelper
    
    def self.verify(token)

      url = "https://challenges.cloudflare.com/turnstile/v0/siteverify"
      body = {
        secret: Secrets.turnstile_secret,
        response: token        
      }
            
      connector = HttpConnector.new
      response = connector.post(url, body)
            
      data = JSON.parse(response.body)
      data["success"]
    end
  end
  
  
end