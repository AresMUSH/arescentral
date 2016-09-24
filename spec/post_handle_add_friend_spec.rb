require_relative 'test_helper'

describe PostHandleAddFriendCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = PostHandleAddFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  

  it "should fail if user doesn't own handle" do
    handle = double
    @handler = PostHandleAddFriendCmd.new({ handle_id: 123}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      

    @handler.handle
  end  

  it "should show flash message and redirect if friend not found" do
    handle = double
    params = { handle_id: 123, friend_id: 234}
    @handler = PostHandleAddFriendCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    Handle.should_receive(:find).with(234) { nil }      
    @server.should_receive(:show_flash).with(:error, "Friend not found.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end  
    
    
  it "should show flash message and redirect if already a friend" do
    handle = double
    friend = double
    params = { handle_id: 123, friend_id: 234}
    @handler = PostHandleAddFriendCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    handle.should_receive(:friends) { [friend] }
    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    Handle.should_receive(:find).with(234) { friend }      
    @server.should_receive(:show_flash).with(:error, "They are already your friend.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end 
  
  it "should create friendship if everything ok" do
    handle = double
    friend = double
    params = { handle_id: 123, friend_id: 234}
    @handler = PostHandleAddFriendCmd.new(params, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    handle.should_receive(:friends) { [] }

    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    Handle.should_receive(:find).with(234) { friend }  
    Friendship.should_receive(:create).with( { owner: handle, friend: friend }) {}
    @server.should_receive(:show_flash).with(:notice, "Friend added!")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle    
  end  
end