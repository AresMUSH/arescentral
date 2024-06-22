require_relative 'test_helper'

module AresCentral
  describe ApiHandleSyncCmd do

    before do    
      @params = { "handle_id" => 345,
        "game_id" => 234,
        "api_key" => 888,
        "char_id" => 123, 
        "char_name" => "Harvey" 
      }
    end
    
    it "should fail if params missing" do 
      required = ApiHandleSyncCmd.required_fields
      required.each do |field|
        @handler = ApiHandleSyncCmd.new(@params.select { |k, v| k != field })
        response = JSON.parse(@handler.handle)
        expect(response["status"]).to eq "failure"
        expect(response["error"]).to eq "Missing required field #{field}."
      end        
    end
        
    it "should fail if the handle is not found" do
      @handler = ApiHandleSyncCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Handle not found."
    end  


    it "should fail if the game is not found" do
      handle = double
      @handler = ApiHandleSyncCmd.new(@params)
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { nil }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Game not found."
    end  
  
    it "should fail if API keys don't match" do
      handle = double
      game = double
      @handler = ApiHandleSyncCmd.new(@params)
      allow(game).to receive(:api_key) { 999 }
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid API key."
    end
  
    it "should return unlinked if the character is not linked" do

      @handler = ApiHandleSyncCmd.new(@params)
    
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
      expect(response["status"]).to eq "success"
      expect(response["data"]["linked"]).to eq false
    end  
    
    it "should return unlinked if the character is there but retired" do

      @handler = ApiHandleSyncCmd.new(@params)
    
      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }

      other_link = double
      expect(other_link).to receive(:char_id) { 123 }
      expect(other_link).to receive(:retired) { true }
      expect(other_link).to receive(:game) { game }

      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ other_link ] }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "success"
      expect(response["data"]["linked"]).to eq false
    end  
  
    it "should update char info if all is well" do
      @handler = ApiHandleSyncCmd.new(@params)

      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(234) { game }
      allow(game).to receive(:api_key) { 888 }

      link = double
      expect(link).to receive(:char_id) { 123 }
      expect(link).to receive(:retired) { false }
      expect(link).to receive(:game) { game }

      f1 = double
      f2 = double
      allow(f1).to receive(:name) { "F1" }
      allow(f2).to receive(:name) { "F2" }
    
      handle = double
      expect(Handle).to receive(:find_by_old_or_new_id).with(345) { handle }
      allow(handle).to receive(:linked_chars) { [ link ] }

      expect(handle).to receive(:autospace) { "a" }
      expect(handle).to receive(:page_autospace) { "pa" }
      expect(handle).to receive(:page_color) { "pc" }
      expect(handle).to receive(:quote_color) { "q" }
      expect(handle).to receive(:timezone) { "tz" }
      expect(handle).to receive(:ascii_only) { true }
      expect(handle).to receive(:screen_reader) { true }
      expect(handle).to receive(:profile) { "my profile" }
      expect(handle).to receive(:friends) { [ f1, f2 ] }

      expect(link).to receive(:update).with(name: "Harvey") 
      
      response = JSON.parse(@handler.handle)

      expect(response["status"]).to eq "success"
      expect(response["data"]["linked"]).to eq true
      expect(response["data"]["autospace"]).to eq "a"
      expect(response["data"]["page_autospace"]).to eq "pa"
      expect(response["data"]["page_color"]).to eq "pc"
      expect(response["data"]["quote_color"]).to eq "q"
      expect(response["data"]["timezone"]).to eq "tz"
      expect(response["data"]["friends"]).to eq [ "F1", "F2" ]
      expect(response["data"]["ascii_only"]).to eq true
      expect(response["data"]["screen_reader"]).to eq true
      expect(response["data"]["profile"]).to eq "my profile"
    end     
  end
end