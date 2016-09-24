require_relative 'test_helper'

describe GetHandleManageFriendCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = GetHandleManageFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)
    
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  
  
  it "should fail if user doesn't own handle" do
    handle = double
    @handler = GetHandleManageFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      

    @handler.handle
  end  

  it "should render template if handle found" do
    handle = double
    @handler = GetHandleManageFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)

    Handle.should_receive(:all) { [] }
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    @server.should_receive(:render_erb).with(:"handles/manage-friend", :layout => :default)

    @handler.handle
    
    @view_data[:handle].should eq handle
    @view_data[:handles].should eq []
  end  
end