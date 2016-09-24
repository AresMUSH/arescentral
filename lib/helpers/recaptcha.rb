class RecaptchaHelper
  def self.verify(response)
      status = `curl "https://www.google.com/recaptcha/api/siteverify?secret=#{Config.recaptcha_secret}&response=#{response}"`
         puts "---------------status ==> #{status}"
         hash = JSON.parse(status)
         hash["success"] == true ? true : false    
    end
end