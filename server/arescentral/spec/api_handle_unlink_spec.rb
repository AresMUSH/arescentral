require_relative 'test_helper'

module AresCentral
  describe ApiHandleUnlinkCmd do

    before do    
      @params = { "handle_id" => 345,
        "game_id" => 234, 
        "api_key" => 888, 
        "char_id" => 123, 
        "char_name" => "Harvey" 
      }
    end
    
    it "should fail if params missing" do 
      required = ApiHandleUnlinkCmd.required_fields
      required.each do |field|
        @handler = ApiHandleUnlinkCmd.new(@params.select { |k, v| k != field })
        response = JSON.parse(@handler.handle)
        expect(response["status"]).to eq "failure"
        expect(response["error"]).to eq "Missing required field #{field}."
      end        
    end
    
    it "should fail if the handle is not found" do
      @handler = ApiHandleUnlinkCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Handle not found."
    end  


    it "should fail if the game is not found" do
      handle = double
      @handler = ApiHandleUnlinkCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { nil }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Game not found."
    end  
  
    it "should fail if API keys don't match" do
      handle = double
      game = double
      @handler = ApiHandleUnlinkCmd.new(@params)
      allow(game).to receive(:api_key) { 999 }
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid API key."
    end
  
    it "should fail if the character isn't linked to that handle" do
      @handler = ApiHandleUnlinkCmd.new(@params)

      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }
    
      another_link = double
      expect(another_link).to receive(:char_id) { 444 }
      expect(another_link).to receive(:game) { game }

      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ another_link ] }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Character not linked to that handle."
    end  
    
    it "should update link status to retired" do
      @handler = ApiHandleUnlinkCmd.new(@params)
      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }

      link = double
      expect(link).to receive(:char_id) { 123 }
      expect(link).to receive(:game) { game }
      expect(link).to receive(:update).with(retired: true)

      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ link ] }

      response = JSON.parse(@handler.handle)

      expect(response["status"]).to eq "success"
    end 
  end
end