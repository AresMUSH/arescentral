require_relative 'test_helper'

module AresCentral
  describe GenerateLinkCodeHandler do

    before do
      @user = double
    end
    
    it "should fail if user not logged in" do
      handler = GenerateLinkCodeHandler.new(nil)
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should fail if too many codes already" do
      handler = GenerateLinkCodeHandler.new(@user)
      expect(@user).to receive(:link_codes) { [ "1", "2", "3", "4", "5" ] }
      expect(@user).to_not receive(:update)
      err = { error: "Please use one of your existing codes." }
      expect(handler.handle).to eq err
    end  
    
    it "should add a new code" do
      handler = GenerateLinkCodeHandler.new(@user)
      expected_codes = [ "1", "2", "3", "4", "5" ]
      expect(@user).to receive(:link_codes) { [ "1", "2", "3", "4" ] }
      expect(SecureRandom).to receive(:uuid) { "5" }
      expect(@user).to receive(:update).with({ link_codes: expected_codes })
      result = { codes: expected_codes }
      expect(handler.handle).to eq result
    end     
  end
end