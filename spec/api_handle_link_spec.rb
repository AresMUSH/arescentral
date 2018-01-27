require_relative 'test_helper'

describe ApiHandleLinkCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if the handle is not found" do
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    Handle.should_receive(:find_by_name).with("Star") { [] }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Handle not found."
  end  


  it "should fail if the game is not found" do
    handle = double
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { nil }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Game not found."
  end  
  
  it "should fail if the API keys don't match" do
    handle = double
    game = double
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { game }
    game.stub(:api_key) { 999 }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Invalid API key."
  end  
  
  it "should fail if the link code is not valid" do
    handle = double
    game = double
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 222, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:link_codes) { [ 111 ]}
    game.stub(:api_key) { 888 }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Invalid link code."
  end  
  
  it "should fail if the character is already linked" do
    handle = double
    game = double
    link = double
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    
    link.should_receive(:char_id) { 123 }
    link.should_receive(:game) { game }
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:link_codes) { [ 111 ]}
    handle.stub(:linked_chars) { [ link ] }
    game.stub(:api_key) { 888 }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "That character is already linked."
  end  
    
  it "should be okay if handle linked to different char on same game" do
    handle = double
    game = double
    link = double
    codes = [ 111, 222 ]    
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    
    LinkedChar.stub(:where) { [] }
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:link_codes) { codes }
    link.should_receive(:char_id) { 766 }
    link.should_receive(:game) { game }
    handle.stub(:linked_chars) { [ link ] }
    handle.stub(:name) { "Star" }
    handle.stub(:id) { 123 }
    game.stub(:api_key) { 888 }
    game.stub(:id) { 234 }
    handle.should_receive(:save!) 
    LinkedChar.should_receive(:create).with(name: "Harvey", handle: handle, game: game, char_id: 123)
    
    JSON.parse(@handler.handle)
  end 
  
  it "should create a link and remove the link code if all is well" do
    handle = double
    game = double
    codes = [ 111, 222 ]    
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    
    LinkedChar.stub(:where) { [] }
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:link_codes) { codes }
    handle.stub(:linked_chars) { [] }
    handle.stub(:name) { "Star" }
    handle.stub(:id) { 123 }
    game.stub(:api_key) { 888 }
    game.stub(:id) { 234 }
    handle.should_receive(:save!) 
    LinkedChar.should_receive(:create).with(name: "Harvey", handle: handle, game: game, char_id: 123)
    
    
    response = JSON.parse(@handler.handle)

    response["status"].should eq "success"
    response["data"]["handle_id"].should eq "123"
    response["data"]["handle_name"].should eq "Star"
        
    codes.should eq [ 222 ]

    
  end 
  
  it "should delete old link to a different handle if one exists" do
    handle = double
    game = double
    codes = [ 111, 222 ]    
    @handler = ApiHandleLinkCmd.new({ handle_name: "Star", game_id: 234, api_key: 888, link_code: 111, char_id: 123, char_name: "Harvey" }, @session, @server, @view_data)
    
    Handle.should_receive(:find_by_name).with("Star") { [handle] }
    Game.should_receive(:find).with(234) { game }
    handle.stub(:link_codes) { codes }
    handle.stub(:linked_chars) { [] }
    handle.stub(:name) { "Star" }
    handle.stub(:id) { 123 }
    game.stub(:api_key) { 888 }
    game.stub(:name) { "A Game" }
    game.stub(:id) { 234 }
    handle.should_receive(:save!) 
    old_link = double
    old_handle = double    
    old_link.stub(:handle) { old_handle }
    old_handle.stub(:past_links) { nil }
    old_link.stub(:display_name) { "Harvey@A Game" }
    
    LinkedChar.should_receive(:create).with(name: "Harvey", handle: handle, game: game, char_id: 123)
    
    LinkedChar.should_receive(:where).with(char_id: 123, game_id: 234) { [ old_link ] } 
    
    old_handle.should_receive(:past_links=).with(["Harvey@A Game"])
    old_handle.should_receive(:save!)
    old_link.should_receive(:destroy!)
      
    response = JSON.parse(@handler.handle)

    response["status"].should eq "success"
   
    
  end 
end