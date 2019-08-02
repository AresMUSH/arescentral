require_relative 'test_helper'

describe ApiHandleSyncCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if the handle is not found" do
    @handler = ApiHandleSyncCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    Handle.should_receive(:find).with(345) { nil }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Handle not found."
  end  


  it "should fail if the game is not found" do
    handle = double
    @handler = ApiHandleSyncCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { nil }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Game not found."
  end  
  
  it "should fail if API keys don't match" do
    handle = double
    game = double
    @handler = ApiHandleSyncCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    game.stub(:api_key) { 999 }
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Invalid API key."
  end
  
  it "should return unlinked if the character is not linked" do
    handle = double
    game = double
    link = double
    @handler = ApiHandleSyncCmd.new({ handle_id: 345, game_id: 234, api_key: 888, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    
    link.should_receive(:char_id) { 444 }
    link.should_receive(:game) { game }
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:linked_chars) { [ link ] }
    game.stub(:api_key) { 888 }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
    response["data"]["linked"].should eq false
  end  
  
  it "should update char info if all is well" do
    handle = double
    game = double
    link = double
    f1 = double
    f2 = double
    @handler = ApiHandleSyncCmd.new({ handle_id: 345, game_id: 234, api_key: 888,  char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    
    Handle.should_receive(:find).with(345) { handle }
    Game.should_receive(:find).with(234) { game }
    link.should_receive(:char_id) { 123 }
    link.should_receive(:game) { game }
    handle.stub(:linked_chars) { [ link ] }
    link.should_receive(:name=).with("Harvey")
    link.should_receive(:save!) 
    handle.should_receive(:autospace) { "a" }
    handle.should_receive(:page_autospace) { "pa" }
    handle.should_receive(:page_color) { "pc" }
    handle.should_receive(:quote_color) { "q" }
    handle.should_receive(:timezone) { "tz" }
    handle.should_receive(:ascii_only) { true }
    handle.should_receive(:screen_reader) { true }
    f1.stub(:name) { "F1" }
    f2.stub(:name) { "F2" }
    game.stub(:api_key) { 888 }
    
    handle.should_receive(:friends) { [ f1, f2 ] }

    response = JSON.parse(@handler.handle)

    response["status"].should eq "success"
    response["data"]["linked"].should eq true
    response["data"]["autospace"].should eq "a"
    response["data"]["page_autospace"].should eq "pa"
    response["data"]["page_color"].should eq "pc"
    response["data"]["quote_color"].should eq "q"
    response["data"]["timezone"].should eq "tz"
    response["data"]["friends"].should eq [ "F1", "F2" ]
    response["data"]["ascii_only"].should eq true
    response["data"]["screen_reader"].should eq true
  end 
end