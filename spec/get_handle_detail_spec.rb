require_relative 'test_helper'

describe GetHandleDetailCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = GetHandleDetailCmd.new({ handle_id: 123}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }
    @handler.handle
  end  

  it "should render template if handle found" do
    handle = double
    @handler = GetHandleDetailCmd.new({ handle_id: 123}, @session, @server, @view_data)

    HandleFinder.should_receive(:find).with(123, @server) { handle }
    @server.should_receive(:render_erb).with(:"handles/detail", :layout => :default)

    @handler.handle
    
    @view_data[:handle].should eq handle
  end  
end