require_relative 'test_helper'

describe PostHandleCharResetPasswordCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if handle not found" do
    @handler = PostHandleCharResetPasswordCmd.new({ handle_id: 123, char_id: 234}, @session, @server, @view_data)
    HandleFinder.should_receive(:find).with(123, @server) { nil }      
    @handler.handle
  end  

  it "should fail if user doesn't own handle" do
    handle = double
    @handler = PostHandleCharResetPasswordCmd.new({ handle_id: 123, char_id: 234}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { false }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      

    @handler.handle
  end  

  it "should fail if char not linked" do
    handle = double
    @handler = PostHandleCharResetPasswordCmd.new({ handle_id: 123, char_id: 234}, @session, @server, @view_data)
    
    OwnerChecker.should_receive(:check).with(@server, handle) { true }    
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    handle.stub(:linked_chars) { [] }
    @server.should_receive(:show_flash).with(:error, "That character is not linked to your handle.")
    @server.should_receive(:redirect_to).with('/handle/123/edit')
    
    @handler.handle
  end
  
  it "should create temp password if everything ok" do
    handle = double
    link = double
    @handler = PostHandleCharResetPasswordCmd.new({ handle_id: 123, char_id: "234"}, @session, @server, @view_data)

    OwnerChecker.should_receive(:check).with(@server, handle) { true }    

    handle.stub(:linked_chars) { [ link ] }
    link.stub(:id) { 234 }
    HandleFinder.should_receive(:find).with(123, @server) { handle }      
    
    link.should_receive(:temp_password=)
    link.should_receive(:save!)
    
    @server.should_receive(:show_flash)
    @server.should_receive(:redirect_to).with('/handle/123/char/manage')
    
    @handler.handle       
  end  
end