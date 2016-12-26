require_relative 'test_helper'

describe ApiResetCharPasswordCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if the handle is not found" do
    @handler = ApiResetCharPasswordCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, password: "123" }, @session, @server, @view_data)
    Handle.should_receive(:find).with(345) { nil }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Handle not found."
  end  


  it "should fail if the game is not found" do
    handle = double
    @handler = ApiResetCharPasswordCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, password: "123" }, @session, @server, @view_data)
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { nil }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Game not found."
  end  
  
  it "should fail if API keys don't match" do
    handle = double
    game = double
    @handler = ApiResetCharPasswordCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, password: "123" }, @session, @server, @view_data)
    game.stub(:api_key) { 999 }
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Invalid API key."
  end
  
  it "should fail if the character is not found" do
    handle = double
    game = double
    link = double
    @handler = ApiResetCharPasswordCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, password: "123" }, @session, @server, @view_data)
    
    link.should_receive(:char_id) { 444 }
    link.should_receive(:game) { game }
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:linked_chars) { [ link ] }
    game.stub(:api_key) { 888 }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
  end  
  
  it "should fail if the passwords don't match" do
    handle = double
    game = double
    link = double    
    @handler = ApiResetCharPasswordCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, password: "123" }, @session, @server, @view_data)
    
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    link.should_receive(:char_id) { 123 }
    link.should_receive(:game) { game }
    handle.stub(:linked_chars) { [ link ] }
    link.should_receive(:temp_password) { "234" }
    game.stub(:api_key) { 888 }
    
    response = JSON.parse(@handler.handle)

    response["status"].should eq "success"
    response["data"]["matched"].should eq false
  end 
  
  it "should return ok and reset temp pw if they match" do
    handle = double
    game = double
    link = double    
    @handler = ApiResetCharPasswordCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, password: "123" }, @session, @server, @view_data)
    
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    link.should_receive(:char_id) { 123 }
    link.should_receive(:game) { game }
    handle.stub(:linked_chars) { [ link ] }
    link.should_receive(:temp_password) { "123" }
    game.stub(:api_key) { 888 }
    link.should_receive(:temp_password=) { nil }
    link.should_receive(:save!)
    
    response = JSON.parse(@handler.handle)

    
    response["status"].should eq "success"
    response["data"]["matched"].should eq true
  end 
end