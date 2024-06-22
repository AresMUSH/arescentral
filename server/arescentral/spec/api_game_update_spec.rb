require_relative 'test_helper'

module AresCentral
  describe ApiGameUpdateCmd do

    before do    
      @params = { "game_id" => 123,
        "api_key" => 456,
        "name" => "Test Game", 
        "host" => "game.aresmush.com", 
        "port" => 4201, 
        "category" => "Other",
        "status" => "Beta",
        "public_game" => true,
        "website" => "somewhere.com",
        "description" => "My game."
      }
    end
    
    it "should fail if params missing" do 
      required = ApiGameUpdateCmd.required_fields
      required.each do |field|
        @handler = ApiGameUpdateCmd.new(@params.select { |k, v| k != field })
        response = JSON.parse(@handler.handle)
        expect(response["status"]).to eq "failure"
        expect(response["error"]).to eq "Missing required field #{field}."
      end        
    end
    
    it "should fail if game not found" do
      @handler = ApiGameUpdateCmd.new(@params)
      expect(Game).to receive(:find_by_old_or_new_id).with(123) { nil }

      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Game not found."
    end  
    
    it "should fail if API key is wrong" do
      @handler = ApiGameUpdateCmd.new(@params)
      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(123) { game }
      allow(game).to receive(:api_key) { 777 }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid API key."
    end  
    
    it "should fail if status is invalid" do
      @params["status"] = "NONE"
      
      @handler = ApiGameUpdateCmd.new(@params)
      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(123) { game }
      allow(game).to receive(:api_key) { 456 }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid game status."
    end  
    
    it "should fail if category is invalid" do
      @params["category"] = "NONE"
      
      @handler = ApiGameUpdateCmd.new(@params)
      game = double
      expect(Game).to receive(:find_by_old_or_new_id).with(123) { game }
      allow(game).to receive(:api_key) { 456 }
    
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid game category."
    end  
        
    it "should save game if everything OK" do
      @handler = ApiGameUpdateCmd.new(@params)
      game = double

      last_update_time = Time.new(2024, 01, 27)
      allow(Time).to receive(:now) { 1 }

      expect(Game).to receive(:find_by_old_or_new_id).with(123) { game }
      allow(game).to receive(:api_key) { 456 }
      allow(game).to receive(:status) { "Beta" }
      allow(game).to receive(:last_status_update) { last_update_time }
    
      update_params = {
        activity: {},
        category: "Other",
        description: "My game.",
        host: "game.aresmush.com",
        last_ping: 1,
        name: "Test Game",
        port: 4201,
        public_game: true,
        status: "Beta",
        website: "somewhere.com",
        last_status_update: last_update_time     
      }
      expect(game).to receive(:update).with(update_params)
    
      response = JSON.parse(@handler.handle)

      expect(response["status"]).to eq "success"
    end  
    
    it "should update last status update time when status changes" do
      @params["status"] = "Open"
      @handler = ApiGameUpdateCmd.new(@params)
      game = double

      last_update_time = Time.new(2024, 01, 27)
      allow(Time).to receive(:now) { 1 }

      expect(Game).to receive(:find_by_old_or_new_id).with(123) { game }
      allow(game).to receive(:api_key) { 456 }
      allow(game).to receive(:status) { "Beta" }
      allow(game).to receive(:last_status_update) { last_update_time }
    
      update_params = {
        activity: {},
        category: "Other",
        description: "My game.",
        host: "game.aresmush.com",
        last_ping: 1,
        name: "Test Game",
        port: 4201,
        public_game: true,
        status: "Open",
        website: "somewhere.com",
        last_status_update: 1     
      }
      expect(game).to receive(:update).with(update_params)
    
      response = JSON.parse(@handler.handle)

      expect(response["status"]).to eq "success"
    end  
  end
end