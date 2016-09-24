require_relative 'test_helper'

describe PostHandleEditCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = PostHandleEditCmd.new({ handle_id: 123}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  

  it "should fail if user doesn't own handle" do
    handle = double
    @handler = PostHandleEditCmd.new({ handle_id: 123}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    
    @handler.handle
  end  

  it "should show flash message and redirect if params invalid" do
    handle = double
    params = { handle_id: 123}
    @handler = PostHandleEditCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    handle.should_receive(:update_from).with(params)
    handle.should_receive(:valid?) { false }
    handle.should_receive(:error_str) { "test" }
    @server.should_receive(:show_flash).with(:error, "test")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end  
    
  it "should save if handle found and params valid" do
    handle = double
    params = { handle_id: 123}
    @handler = PostHandleEditCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    handle.should_receive(:update_from).with(params)
    handle.should_receive(:valid?) { true }
    handle.should_receive(:save!)
    @server.should_receive(:show_flash).with(:notice, "Handle updated!")
    @server.should_receive(:redirect_to).with('/')
    
    @handler.handle    
  end  
end