require_relative 'test_helper'

module AresCentral
  describe ApiResetCharPasswordCmd do

    before do    
      @server = double
      @session = {}
      @view_data = {}
      @params = { "handle_id" => 345,
        "game_id" => 234, 
        "api_key" => 888, 
        "char_id" => 123, 
        "password" => "123" }
    end
    
    it "should fail if params missing" do 
      required = ApiResetCharPasswordCmd.required_fields
      required.each do |field|
        @handler = ApiResetCharPasswordCmd.new(@params.select { |k, v| k != field })
        response = JSON.parse(@handler.handle)
        expect(response["status"]).to eq "failure"
        expect(response["error"]).to eq "Missing required field #{field}."
      end        
    end
    
    it "should fail if the handle is not found" do
      @handler = ApiResetCharPasswordCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Handle not found."
    end  


    it "should fail if the game is not found" do
      handle = double
      @handler = ApiResetCharPasswordCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { nil }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Game not found."
    end  
  
    it "should fail if API keys don't match" do
      handle = double
      game = double
      @handler = ApiResetCharPasswordCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      expect(game).to receive(:api_key) { 999 }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid API key."
    end
  
    it "should fail if the character is not found" do
      @handler = ApiResetCharPasswordCmd.new(@params)

      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }
    
      other_link = double
      expect(other_link).to receive(:char_id) { 444 }
      expect(other_link).to receive(:game) { game }

      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ other_link ] }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
    end  
  
    it "should fail if the passwords don't match" do
      @handler = ApiResetCharPasswordCmd.new(@params)

      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }

      link = double    
      expect(link).to receive(:char_id) { 123 }
      expect(link).to receive(:game) { game }
    
      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ link ] }

      expect(link).to receive(:temp_password) { "234" }
    
      response = JSON.parse(@handler.handle)

      expect(response["status"]).to eq "success"
      expect(response["data"]["matched"]).to eq false
    end 
  
    it "should return ok and reset temp pw if they match" do
      @handler = ApiResetCharPasswordCmd.new(@params)

      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }

      link = double    
      expect(link).to receive(:char_id) { 123 }
      expect(link).to receive(:game) { game }

      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ link ] }


      expect(link).to receive(:temp_password) { "123" }
      expect(link).to receive(:update).with(temp_password: nil)
    
      response = JSON.parse(@handler.handle)
    
      expect(response["status"]).to eq "success"
      expect(response["data"]["matched"]).to eq true
    end 
  end
end