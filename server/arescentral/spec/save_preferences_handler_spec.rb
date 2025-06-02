require_relative 'test_helper'

module AresCentral

  describe SavePreferencesHandler do

    before do      
      @user = double
      allow(@user).to receive(:id) { "123" }
    end
    
    it "should fail if not logged in" do
      @user = nil
      handler = SavePreferencesHandler.new(@user, {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
        
    
    it "should fail if the security question is blank" do
      body = { 'handle_id' => "123" }
      handler = SavePreferencesHandler.new(@user, body)
      expect(@user).to receive(:id) { "123" }
      expect(@user).to_not receive(:update)
      err = { error: "Security question (favorite MU*) is required." }
      expect(handler.handle).to eq err
    end
    
    it "should fail if the timezone is not valid" do
      body = { 'handle_id' => "123", "preferences" => { 'timezone' => "NONE", 'security_question' => "X" }}
      handler = SavePreferencesHandler.new(@user, body)
      expect(@user).to receive(:id) { "123" }
      expect(@user).to_not receive(:update)
      err = { error: "Invalid timezone." }
      expect(handler.handle).to eq err
    end
    
    
    it "should update the handle if everything's OK" do
      body = { 'handle_id' => "123", "preferences" => { 'timezone' => "America/New_York", 'security_question' => "X" }}
      handler = SavePreferencesHandler.new(@user, body)
      expect(@user).to receive(:id) { "123" }
      expect(@user).to receive(:update)
      response = {}
      expect(handler.handle).to eq response      
    end
    
  end
end