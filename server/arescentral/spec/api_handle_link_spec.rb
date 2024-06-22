require_relative 'test_helper'

module AresCentral
  describe ApiHandleLinkCmd do

    before do    
      @params = { 
        "handle_name" => "Star", 
        "game_id" => 234, 
        "api_key" => 888, 
        "link_code" => 111, 
        "char_id" => 789, 
        "char_name" => "Harvey" 
      }
    end
    
    it "should fail if params missing" do 
      required = ApiHandleLinkCmd.required_fields
      required.each do |field|
        @handler = ApiHandleLinkCmd.new(@params.select { |k, v| k != field })
        response = JSON.parse(@handler.handle)
        expect(response["status"]).to eq "failure"
        expect(response["error"]).to eq "Missing required field #{field}."
      end        
    end
    
    it "should fail if the handle is not found" do
      @handler = ApiHandleLinkCmd.new(@params)
      expect(Handle).to receive(:find_by_name).with("Star") { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Handle not found."
    end  


    it "should fail if the game is not found" do
      handle = double
      @handler = ApiHandleLinkCmd.new(@params)
      expect(Handle).to receive(:find_by_name).with("Star") { [handle] }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { nil }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Game not found."
    end  
  
    it "should fail if the API keys don't match" do
      handle = double
      game = double
      @handler = ApiHandleLinkCmd.new(@params)
      expect(Handle).to receive(:find_by_name).with("Star") { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 999 }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid API key."
    end  
  
    it "should fail if the link code is not valid" do
      @handler = ApiHandleLinkCmd.new(@params)

      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }

      handle = double
      expect(Handle).to receive(:find_by_name).with("Star") { handle }
      allow(handle).to receive(:link_codes) { [ 222 ]}
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid link code."
    end  
    
    
    it "should create the link and remove the code" do
      @handler = ApiHandleLinkCmd.new(@params)
    
      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }
    
      codes = [ 111, 222 ]    
      handle = double
      expect(Handle).to receive(:find_by_name).with("Star") { handle }
      allow(handle).to receive(:link_codes) { codes }
      allow(handle).to receive(:linked_chars) { [] }
      allow(handle).to receive(:name) { "Star" }
      allow(handle).to receive(:id) { 123 }

      expect(handle).to receive(:update).with(link_codes: [ 222 ])
      expect(game).to receive(:create_or_update_linked_char).with("Harvey", 789, handle)
    
      expected_data = {
        "handle_name" => "Star",
        "handle_id" => "123"
      }
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "success"
      expect(response["data"]).to eq expected_data
    end 
    
    
  end
end