require_relative 'test_helper'

module AresCentral

  describe SsoLoginHandler do

    before do     
      @handle = double
    end

    it "should show fail if SSO request not found" do
      body = { 'name' => "Jack", "password" => "Rose" }
      expect(Handle).to receive(:find_by_name).with("Jack") { nil }
      handler = SsoLoginHandler.new(body)
      err = { error: "Invalid SSO request." }
      expect(handler.handle).to eq err
    end  
        
    it "should show fail if handle not found" do
      body = { 'name' => "Jack", "password" => "Rose", "sso_request" => "123" }
      expect(Handle).to receive(:find_by_name).with("Jack") { nil }
      handler = SsoLoginHandler.new(body)
      err = { error: "Invalid username or password." }
      expect(handler.handle).to eq err
    end  

    it "should fail if handle is banned" do
      body = { 'name' => "Jack", "password" => "Rose", "sso_request" => "123" }
      allow(@handle).to receive(:forum_banned) { true }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      handler = SsoLoginHandler.new(body)
      err = { error: "Your forum privileges have been revoked. Contact the AresCentral admin if you believe this to be in error." }
      expect(handler.handle).to eq err
    end
      
    it "should fail if handle has no email" do
      body = { 'name' => "Jack", "password" => "Rose", "sso_request" => "123" }
      allow(@handle).to receive(:forum_banned) { false }
      allow(@handle).to receive(:email) { nil }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      handler = SsoLoginHandler.new(body)
      err = { error: "The forum uses email registration, so you must have an email configured in your player handle settings. Go to 'My Account' on AresCentral to set one." }
      expect(handler.handle).to eq err
    end
    
    it "should fail if password doesn't match" do
      body = { 'name' => "Jack", "password" => "Rose", "sso_request" => "123" }
      allow(@handle).to receive(:forum_banned) { false }
      allow(@handle).to receive(:email) { "somebody@somewhere.com" }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to receive(:compare_password).with("Rose") { false }
      handler = SsoLoginHandler.new(body)
      err = { error: "Invalid username or password." }
      expect(handler.handle).to eq err
    end    
    
    it "should succeed if pw matches" do
      body = { 'name' => "Jack", "password" => "Rose", "sso_request" => "123" }
      allow(@handle).to receive(:forum_banned) { false }
      allow(@handle).to receive(:email) { "somebody@somewhere.com" }
      allow(@handle).to receive(:name) { "Jack" }
      allow(@handle).to receive(:id) { "111" }
      allow(@handle).to receive(:profile) { "Profile" }
      allow(@handle).to receive(:image_url) { "myimage.jpg" }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to receive(:compare_password).with("Rose") { true }
      
      sso = double
      expect(SingleSignOn).to receive(:parse).with("123", Secrets.forum_secret) { sso }

      expect(sso).to receive(:email=).with("somebody@somewhere.com")
      expect(sso).to receive(:username=).with("Jack")
      expect(sso).to receive(:name=).with("Jack")
      expect(sso).to receive(:external_id=).with("111")
      expect(sso).to receive(:require_activation=).with(true)
      expect(sso).to receive(:bio=).with("Profile")
      expect(sso).to receive(:avatar_url=).with("myimage.jpg")
      expect(sso).to receive(:sso_secret=).with(Secrets.forum_secret)
      expect(sso).to receive(:to_url) { "URL" }
      
      handler = SsoLoginHandler.new(body)
      response = { redirect_url: "URL" }
      expect(handler.handle).to eq response
    end
  end
end