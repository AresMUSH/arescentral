require_relative 'test_helper'

module AresCentral
  describe ResetPlayerPasswordHandler do

    before do    
      @user = double
    end
    
    it "should fail if user is not admin" do
      @handler = ResetPlayerPasswordHandler.new(@user, {})
      expect(@user).to receive(:is_admin?) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end  
    
    it "should fail if handle not found" do
      @handler = ResetPlayerPasswordHandler.new(@user, { "handle_id" => "123" })
      expect(@user).to receive(:is_admin?) { true }
      
      expect(Handle).to receive(:find_by_name_or_id).with("123") { nil }
      
      err = { error: "Handle not found." }
      expect(@handler.handle).to eq err
    end  
    
    it "should reset password" do
      @handler = ResetPlayerPasswordHandler.new(@user, { "handle_id" => "123" })
      expect(@user).to receive(:is_admin?) { true }
      
      handle = double
      expect(Handle).to receive(:find_by_name_or_id).with("123") { handle }
      expect(handle).to receive(:reset_password) { "NEW_PW"}
      allow(handle).to receive(:name) { "Bob" }
      allow(@user).to receive(:name) { "Faraday" }
      response = { password: "NEW_PW" }
      expect(@handler.handle).to eq response
    end  
    
  end
end