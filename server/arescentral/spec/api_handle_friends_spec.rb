require_relative 'test_helper'

module AresCentral
  describe ApiHandleFriendsCmd do

    before do    
      @params = { "handle_id" => 123 }
    end
    
    it "should fail if the handle is not found" do
      @handler = ApiHandleFriendsCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(123) { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Handle not found."
    end  

    it "should return friends" do
      @handler = ApiHandleFriendsCmd.new(@params)

      f1 = double
      f2 = double
      allow(f1).to receive(:name) { "F1" }
      allow(f2).to receive(:name) { "F2" }
    
      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(123) { handle }
      expect(handle).to receive(:friends) { [ f1, f2 ] }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "success"
      expect(response["data"]["friends"]).to eq [ "F1", "F2" ]
    end 
  end
end