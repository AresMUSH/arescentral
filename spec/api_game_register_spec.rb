require_relative 'test_helper'

describe ApiGameRegisterCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if game missing fields" do
    @handler = ApiGameRegisterCmd.new({ name: "test"}, @session, @server, @view_data)
    game = double
    Game.should_receive(:new) { game }
    game.should_receive(:valid?) { false }
    game.should_receive(:update_from).with({ name: "test"})
    game.stub(:error_str) { "Errors" }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Errors"
  end  

  it "should save game if everything OK" do
    @handler = ApiGameRegisterCmd.new({ name: "test"}, @session, @server, @view_data)
    game = double
    Game.should_receive(:new) { game }
    game.stub(:api_key) { "ABC" }
    game.stub(:id) { "123" }
    game.should_receive(:valid?) { true }
    game.should_receive(:update_from).with({ name: "test"})
    game.should_receive(:save!)
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
    response["data"]["api_key"].should eq "ABC"
    response["data"]["game_id"].should eq "123"
  end  
end