require_relative 'test_helper'

module AresCentral
  describe ChangePasswordHandler do

    before do
      @user = double
    end
    
    it "should fail if user not logged in" do
      handler = ChangePasswordHandler.new(nil, {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should fail if old password doesn't match" do
      handler = ChangePasswordHandler.new(@user, {"old_password" => "OLD", "new_password" => "NEW" })
      expect(@user).to receive(:compare_password).with("OLD") { false }
      expect(@user).to_not receive(:change_password)
      error = { error: "Old password doesn't match." }
      expect(handler.handle).to eq error 
    end  
    
    it "should fail if password is not valid" do
      handler = ChangePasswordHandler.new(@user, {"old_password" => "OLD", "new_password" => "NEW" })
      expect(@user).to receive(:compare_password).with("OLD") { true }
      expect(Handle).to receive(:check_password_requirements).with("NEW") { "PW INVALID" }
      expect(@user).to_not receive(:change_password)
      error = { error: "PW INVALID" }
      expect(handler.handle).to eq error 
    end  
    
    it "should fail if password is the same" do
      handler = ChangePasswordHandler.new(@user, {"old_password" => "OLD", "new_password" => "OLD" })
      expect(@user).to_not receive(:change_password)
      error = { error: "Old and new passwords can't be the same." }
      expect(handler.handle).to eq error 
    end  

    it "should change password if everything is OK" do
      handler = ChangePasswordHandler.new(@user, {"old_password" => "OLD", "new_password" => "NEW" })
      expect(@user).to receive(:compare_password).with("OLD") { true }
      expect(Handle).to receive(:check_password_requirements).with("NEW") { nil }
      expect(@user).to receive(:change_password).with("NEW")
      response = {}
      expect(handler.handle).to eq response
    end    
  end
end