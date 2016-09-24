require_relative 'test_helper'

describe PostHandleDeleteFriendCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = PostHandleDeleteFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  

  it "should fail if user doesn't own handle" do
    handle = double
    @handler = PostHandleDeleteFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      

    @handler.handle
  end  

  it "should show flash message and redirect if friend not found" do
    handle = double
    params = { handle_id: 123, friend_id: 234}
    @handler = PostHandleDeleteFriendCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    Handle.should_receive(:find).with(234) { nil }      
    @server.should_receive(:show_flash).with(:error, "Friend not found.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end  
    
    
  it "should show flash message and redirect if not already a friend" do
    handle = double
    friend = double
    params = { handle_id: 123, friend_id: 234}
    @handler = PostHandleDeleteFriendCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    handle.should_receive(:friendships) { [] }
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    Handle.should_receive(:find).with(234) { friend }      
    @server.should_receive(:show_flash).with(:error, "They are not your friend.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end 
  
  it "should create friendship if everything ok" do
    handle = double
    friend = double
    friendship = double
    params = { handle_id: 123, friend_id: 234}
    @handler = PostHandleDeleteFriendCmd.new(params, @session, @server, @view_data)

    friendship.stub(:friend) { friend }
    handle.should_receive(:friendships) { [friendship] }
    OwnerChecker.should_receive(:check).with(@server, handle) { true }    

    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    Handle.should_receive(:find).with(234) { friend }  
    friendship.should_receive(:destroy!)
    @server.should_receive(:show_flash).with(:notice, "Friend deleted!")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle    
  end  
end