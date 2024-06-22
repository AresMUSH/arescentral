require_relative 'test_helper'

module AresCentral

  describe RegisterHandler do

    before do     
      @user = nil
       
      #RecaptchaHelper.stub(:verify) { true }
      allow(Handle).to receive(:check_name_requirements) { nil }
      allow(Handle).to receive(:check_password_requirements) { nil }

      allow(File).to receive(:read).with('banned.txt') { "789\n456"}
      allow(TurnstileHelper).to receive(:verify) { true }
    end
    
    it "should fail if user is logged in" do
      @user = double
      handler = RegisterHandler.new(@user, "123", {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should show fail if name invalid" do
      body = { 'name' => "Jack" }
      expect(Handle).to receive(:check_name_requirements).with("Jack") { "Invalid" }
      handler = RegisterHandler.new(@user, "123", body)
      err = { error: 'Invalid' }
      expect(handler.handle).to eq err
    end  
  
    it "should fail if name already exists" do
      body = { 'name' => "Jack" }
      expect(Handle).to receive(:find_by_name).with("Jack") { double }
      handler = RegisterHandler.new(@user, "123", body)
      err = { error: 'Handle already exists.' }
      expect(handler.handle).to eq err
    end
    
    it "should fail if password invalid" do
      body = { 'name' => "Jack", 'password' => 'mypw' }
      expect(Handle).to receive(:check_password_requirements).with("mypw") { "Invalid" }
      handler = RegisterHandler.new(@user, "123", body)
      err = { error: 'Invalid' }
      expect(handler.handle).to eq err
    end  
    
    it "should fail if captcha invalid" do
      body = { 'name' => "Jack", 'password' => 'mypw', 'captcha' => 'token' }
      handler = RegisterHandler.new(@user, "123", body)
      expect(TurnstileHelper).to receive(:verify).with("token") { false }
      err = { error: "Captcha verification failed. If you're not a bot, please try again in a bit." }
      expect(handler.handle).to eq err
    end       

    it "should save if handle is new and params valid" do
      body = { 'name' => "Jack", 'password' => 'mypw', 'security_question' => 'secret', 'email' => 'email@example.com' }
      handler = RegisterHandler.new(@user, "123", body)
      handle = double
      allow(handle).to receive(:name) { "Jack" }
      allow(handle).to receive(:id) { "1" }
      allow(handle).to receive(:auth_token) { "token" }
      allow(handle).to receive(:is_admin) { false }
      expect(Handle).to receive(:find_by_name).with("Jack") { nil }
      expect(Handle).to receive(:create) do |params|
        expect(params[:name]).to eq "Jack"
        expect(params[:security_question]).to eq "secret"
        expect(params[:email]).to eq "email@example.com"
        handle
      end
      expect(handle).to receive(:change_password).with("mypw")
      expect(handle).to receive(:set_auth_token)
      expect(handle).to receive(:auth_token_expiry) { "123" }
      data = handler.handle
      expected_data = { name: "Jack", id: "1", token: "token", is_admin: false, expires: 123 }
      expect(data).to eq expected_data
    end
  end
end