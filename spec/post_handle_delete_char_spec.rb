require_relative 'test_helper'

describe PostHandleDeleteCharCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = PostHandleDeleteCharCmd.new({ handle_id: 123}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  

  it "should fail if user doesn't own handle" do
    handle = double
    @handler = PostHandleDeleteCharCmd.new({ handle_id: 123}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      

    @handler.handle
  end  

  it "should fail if char not linked" do
    handle = double
    @handler = PostHandleDeleteCharCmd.new({ handle_id: 123, char_id: 234}, @session, @server, @view_data)
    
    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    handle.stub(:linked_chars) { [] }
    @server.should_receive(:show_flash).with(:error, "That character is not linked to your handle.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end
  
  it "should remove link and add to past chars if everything ok" do
    handle = double
    link = double
    params = { handle_id: 123, char_id: "234" }
    @handler = PostHandleDeleteCharCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    

    handle.stub(:linked_chars) { [ link ] }
    link.stub(:id) { 234 }
    link.stub(:display_name) { "Bob@A Game" }
    
    handle.should_receive(:add_past_link).with(link)
    handle.should_receive(:save!)
    
    link.should_receive(:destroy!)
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    
    @server.should_receive(:show_flash).with(:notice, "Character unlinked.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle       
  end   
end