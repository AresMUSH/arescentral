require_relative 'test_helper'

describe ApiGameRegisterCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if game missing fields" do
    @handler = ApiGameRegisterCmd.new({ name: "Test", host: "somewhere.com", port: 1234 }, @session, @server, @view_data)
    game = double
    Game.should_receive(:where).with(name: "Test", host: "somewhere.com", port: 1234) { [ ]}
    Game.should_receive(:new) { game }
    game.should_receive(:valid?) { false }
    game.should_receive(:update_from).with({ name: "Test", host: "somewhere.com", port: 1234 })
    game.stub(:error_str) { "Errors" }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Errors"
  end  

  it "should save game if everything OK" do
    @handler = ApiGameRegisterCmd.new({ name: "Test", host: "somewhere.com", port: 1234 }, @session, @server, @view_data)
    game = double
    Game.should_receive(:where).with(name: "Test", host: "somewhere.com", port: 1234) { [ ]}
    Game.should_receive(:new) { game }
    game.stub(:api_key) { "ABC" }
    game.stub(:id) { "123" }
    game.should_receive(:valid?) { true }
    game.should_receive(:update_from).with({ name: "Test", host: "somewhere.com", port: 1234 })
    game.should_receive(:save!)
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
    response["data"]["api_key"].should eq "ABC"
    response["data"]["game_id"].should eq "123"
  end  
  
  it "should return an existing game if there's an exact match" do
    game = double
    game.stub(:id) { "123" }
    game.stub(:api_key) { "ABC" }
    
    Game.should_receive(:where).with(name: "Test", host: "somewhere.com", port: 1234) { [ game ]}
    
    @handler = ApiGameRegisterCmd.new({ name: "Test", host: "somewhere.com", port: 1234 }, @session, @server, @view_data)

    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
    response["data"]["game_id"].should eq "123"
    response["data"]["api_key"].should eq "ABC"
  end  
end