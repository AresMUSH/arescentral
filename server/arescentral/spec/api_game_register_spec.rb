require_relative 'test_helper'

module AresCentral
  describe ApiGameRegisterCmd do

    before do
      @params = {
        "game_id" => 123,
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
      required = ApiGameRegisterCmd.required_fields
      required.each do |field|
        @handler = ApiGameRegisterCmd.new(@params.select { |k, v| k != field })
        response = JSON.parse(@handler.handle)
        expect(response["status"]).to eq "failure"
        expect(response["error"]).to eq "Missing required field #{field}."
      end        
    end
  
    it "should fail if status is invalid" do
      tmp_params = @params
      tmp_params["status"] = "NONE"
    
      @handler = ApiGameRegisterCmd.new(tmp_params)
  
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid game status."
    end  
  
    it "should fail if category is invalid" do
      tmp_params = @params
      tmp_params["category"] = "NONE"
    
      @handler = ApiGameRegisterCmd.new(tmp_params)
  
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "failure"
      expect(response["error"]).to eq "Invalid game category."
    end  
  
    it "should not create a new game if a duplicate exists" do
      game = double
      expect(game).to receive(:id) { "123" }
      expect(game).to receive(:name) { "Test Game" }
      expect(game).to receive(:host) { "game.aresmush.com" }
      expect(game).to receive(:port) { 4201 }
      expect(game).to receive(:api_key) { "ABC" }
      expect(Game).to receive(:all) { [ game ] }
    
      @handler = ApiGameRegisterCmd.new(@params)
      expect(Game).to_not receive(:create)
    
      response = JSON.parse(@handler.handle)
    
      expect(response["status"]).to eq "success"
      expect(response["data"]["game_id"]).to eq "123"
      expect(response["data"]["api_key"]).to eq "ABC"
    end

    it "should create game if everything OK" do
      @handler = ApiGameRegisterCmd.new(@params)
    
      old_game = double
      expect(Game).to receive(:all) {[ old_game ]}
      allow(old_game).to receive(:name) { "Different Game" }
      allow(old_game).to receive(:host) { "game2.aresmush.com" }
      allow(old_game).to receive(:port) { 4201 }
    
      create_params = {
        activity: {},
        category: "Other",
        description: "My game.",
        host: "game.aresmush.com",
        last_ping: 1,
        name: "Test Game",
        port: 4201,
        public_game: true,
        status: "Beta",
        website: "somewhere.com"        
      }
      
      new_game = double("NEWGAME")
      expect(Game).to receive(:create) { new_game }
      expect(new_game).to receive(:id) { "555" }
      expect(new_game).to receive(:api_key) { "ABC"}

      allow(Time).to receive(:now) { 1 }
      
      response = JSON.parse(@handler.handle)
      expect(response["status"]).to eq "success"
      expect(response["data"]["api_key"]).to eq "ABC"
      expect(response["data"]["game_id"]).to eq "555"
    end  
  end
end