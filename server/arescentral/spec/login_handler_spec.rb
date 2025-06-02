require_relative 'test_helper'

module AresCentral

  describe LoginHandler do

    before do     
      @user = nil
      @handle = double
      allow(@handle).to receive(:login_lockout_time) { nil }
      allow(@handle).to receive(:login_failures) { 0 }
      allow(File).to receive(:read).with('banned.txt') { "789\n456"}
    end
    
    it "should fail if user is logged in" do
      @user = double
      handler = LoginHandler.new(@user,{})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should show fail if handle not found" do
      body = { 'name' => "Jack", "password" => "Rose" }
      expect(Handle).to receive(:find_by_name).with("Jack") { nil }
      handler = LoginHandler.new(@user, body)
      expect(Authorization).to_not receive(:build_login_session)
      err = { error: "That is not a valid username/password." }
      expect(handler.handle).to eq err
    end  
  
    it "should fail and increment fail count if pw doesn't match" do
      body = { 'name' => "Jack", "password" => "Rose" }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to receive(:compare_password) { false }
      expect(@handle).to receive(:update).with(login_failures: 1)
      expect(Authorization).to_not receive(:build_login_session)
      handler = LoginHandler.new(@user, body)
      err = { error: "That is not a valid username/password." }
      expect(handler.handle).to eq err
    end
    
    it "should set lockout time and reset fail counter after too many failures" do
      body = { 'name' => "Jack", "password" => "Rose" }
      allow(Time).to receive(:now) { 1000 }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to receive(:compare_password) { false }
      allow(@handle).to receive(:login_failures) { 5 }
      expect(@handle).to receive(:update).with(login_lockout_time: 4600)
      expect(@handle).to receive(:update).with(login_failures: 0)
      expect(Authorization).to_not receive(:build_login_session)
      handler = LoginHandler.new(@user, body)
      err = { error: "That is not a valid username/password." }
      expect(handler.handle).to eq err
    end
    
    it "should fail if in lockout time" do
      body = { 'name' => "Jack", "password" => "Rose" }
      allow(Time).to receive(:now) { 3000 }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to_not receive(:compare_password)
      allow(@handle).to receive(:login_lockout_time) { 4600 }
      expect(Authorization).to_not receive(:build_login_session)
      handler = LoginHandler.new(@user, body)
      err = { error: "Too many failed logins. Try back later." }
      expect(handler.handle).to eq err
    end
    
    it "should be okay once lockout time has passed" do
      body = { 'name' => "Jack", "password" => "Rose" }
      allow(Time).to receive(:now) { 1000 }
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to receive(:compare_password) { false }
      allow(Time).to receive(:now) { 5000 }
      allow(@handle).to receive(:login_lockout_time) { 4600 }
      expect(@handle).to receive(:update).with(login_failures: 1)
      expect(Authorization).to_not receive(:build_login_session)
      handler = LoginHandler.new(@user, body)
      err = { error: "That is not a valid username/password." }
      expect(handler.handle).to eq err
    end
    
    it "should succeed if pw matches and reset failures" do
      body = { 'name' => "Jack", "password" => "Rose" }
      auth = double
      expect(Handle).to receive(:find_by_name).with("Jack") { @handle }
      expect(@handle).to receive(:compare_password) { true }
      expect(@handle).to receive(:set_auth_token)
      expect(@handle).to receive(:update).with(login_lockout_time: nil)
      expect(@handle).to receive(:update).with(login_failures: 0)
      expect(Authorization).to receive(:build_login_session).with(@handle) { auth }
      handler = LoginHandler.new(@user, body)
      expect(handler.handle).to eq auth
    end
  end
end