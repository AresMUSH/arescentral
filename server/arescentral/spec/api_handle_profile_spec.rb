require_relative 'test_helper'

module AresCentral
  describe ApiHandleProfileCmd do

    before do    
    end
    
    it "should fail if the handle is not found" do
      @handler = ApiHandleProfileCmd.new({ "handle_id" => 123 })
      expect(Handle).to receive(:find_by_old_or_new_id).with(123) { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Handle not found."
    end  

    it "should return profile" do
      handle = double
      @handler = ApiHandleProfileCmd.new({ "handle_id" => 123 })
    
      expect(Handle).to receive(:find_by_old_or_new_id).with(123) { handle }
      expect(handle).to receive(:profile) { "A Profile" }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "success"
      expect(response["data"]["profile"]).to eq "A Profile"    
    end 
  end
end