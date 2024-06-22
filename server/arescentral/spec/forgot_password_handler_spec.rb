require_relative 'test_helper'

module AresCentral
  describe ForgotPasswordHandler do

    before do
    end
    
    it "should do nothing if name blank" do
      @handler = ForgotPasswordHandler.new({"email" => "foo@example.com"})
      expect(Mailer).to_not receive(:send)
      expect(@handler.handle).to be {}
    end  
    
    it "should do nothing if email blank" do
      @handler = ForgotPasswordHandler.new({"email" => "foo"})
      expect(Mailer).to_not receive(:send)
      expect(@handler.handle).to be {}
    end  

    it "should do nothing if handle not found" do
      @handler = ForgotPasswordHandler.new({"email" => "foo@example.com", "name" => "foo" })
      expect(Handle).to receive(:find_by_name).with("foo") { nil }
      expect(Mailer).to_not receive(:send)
      expect(@handler.handle).to be {}
    end
    
    it "should do nothing if handle email doesn't match specified one" do
      @handler = ForgotPasswordHandler.new({"email" => "foo@example.com", "name" => "foo" })
      handle = double
      expect(Handle).to receive(:find_by_name).with("foo") { handle }
      expect(handle).to receive(:email) { "bar@example.com" }
      expect(Mailer).to_not receive(:send)
      expect(@handler.handle).to be {}
    end
    
    it "should reset pw and send email if handle and email match" do
      @handler = ForgotPasswordHandler.new({"email" => "foo@example.com", "name" => "foo" })
      handle = double
      expect(Handle).to receive(:find_by_name).with("foo") { handle }
      expect(handle).to receive(:email) { "foo@example.com" }.twice
      expect(handle).to receive(:reset_password) { "newpw" }
      allow(handle).to receive(:name) { "foo" }
      expect(Mailer).to receive(:send).with("foo@example.com", 
         "AresCentral Password Reset", 
         "Your password has been reset to: newpw.  Please log in and reset it.")
      expect(@handler.handle).to be {}
    end
  end
end