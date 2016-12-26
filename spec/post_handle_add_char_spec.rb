require_relative 'test_helper'

describe PostHandleAddCharCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = PostHandleAddCharCmd.new({ handle_id: 123}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  

  it "should fail if user doesn't own handle" do
    handle = double
    @handler = PostHandleAddCharCmd.new({ handle_id: 123}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      

    @handler.handle
  end  

  
  it "should create link code if everything ok" do
    handle = double
    codes = []
    params = { handle_id: 123 }
    @handler = PostHandleAddCharCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    

    handle.stub(:name) { "Bob" }
    handle.stub(:link_codes) { codes }
    handle.should_receive(:save!)
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    SecureRandom.stub(:uuid) { "123" }
    
    @server.should_receive(:show_flash)
    @server.should_receive(:redirect_to).with('/handle/123/char/manage')
    
    @handler.handle   
    
    codes[0].should eq "123" 
    
  end  
end