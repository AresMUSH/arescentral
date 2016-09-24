require_relative 'test_helper'

describe ApiGameUpdateCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if game not found" do
    @handler = ApiGameUpdateCmd.new({ game_id: 123}, @session, @server, @view_data)
    Game.should_receive(:find).with(123) { nil }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Game not found."
  end  
    
  it "should fail if API key is wrong" do
    @handler = ApiGameUpdateCmd.new({ game_id: 123, api_key: 456 }, @session, @server, @view_data)
    game = double
    game.stub(:api_key) { 777 }
    
    Game.should_receive(:find).with(123) { game }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Invalid API key."
  end  
    
  it "should fail if game missing fields" do
    @handler = ApiGameUpdateCmd.new({ game_id: 123, api_key: 456}, @session, @server, @view_data)
    game = double
    game.stub(:api_key) { 456 }

    Game.should_receive(:find).with(123) { game }
    game.should_receive(:valid?) { false }
    game.should_receive(:update_from).with({ game_id: 123, api_key: 456})
    game.stub(:error_str) { "Errors" }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Errors"
  end  

  it "should save game if everything OK" do
    @handler = ApiGameUpdateCmd.new({ game_id: 123, api_key: 456}, @session, @server, @view_data)
    game = double
    Game.should_receive(:find).with(123) { game }
    game.stub(:api_key) { 456 }
    game.should_receive(:valid?) { true }
    Time.stub(:now) { 1 }
    
    game.should_receive(:last_ping=).with(1)
    game.should_receive(:update_from)
    game.should_receive(:save!)
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
  end  
end