require_relative 'test_helper'

describe PostHandleCreateCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
    
    RecaptchaHelper.stub(:verify) { true }
  end
    
  it "should show flash message and redirect if handle params invalid" do
    handle = double
    params = { name: "Star"}
    @handler = PostHandleCreateCmd.new(params, @session, @server, @view_data)

    Handle.should_receive(:new) { handle }     
    handle.should_receive(:create_from).with(params)
    handle.should_receive(:valid?) { false }
    handle.should_receive(:error_str) { "test" }
    
    @server.should_receive(:ip_addr) { "123" }
    @server.should_receive(:show_flash).with(:error, "test")
    @server.should_receive(:redirect_to).with('/handle/create')

    @handler.handle
  end  
  
    
  it "should show flash message and redirect if IP banned" do
    params = { name: "Star"}
    @handler = PostHandleCreateCmd.new(params, @session, @server, @view_data)

    File.stub(:read).with('banned.txt') { "123\n456"}
    File.stub(:read).with('blacklist.txt') { "789"}
    
    @server.should_receive(:ip_addr) { "123" }
    @server.should_receive(:show_flash).with(:error, "You cannot create a handle at this time.  Your site has been banned, or you're connected from a proxy/VPN server that's on our blacklist.")
    @server.should_receive(:redirect_to).with('/')

    @handler.handle
  end  
  
  it "should show flash message and redirect if IP blacklisted" do
    params = { name: "Star"}
    @handler = PostHandleCreateCmd.new(params, @session, @server, @view_data)

    File.stub(:read).with('banned.txt') { "123\n456"}
    File.stub(:read).with('blacklist.txt') { "789"}
    
    @server.should_receive(:ip_addr) { "789" }
    @server.should_receive(:show_flash).with(:error, "You cannot create a handle at this time.  Your site has been banned, or you're connected from a proxy/VPN server that's on our blacklist.")
    @server.should_receive(:redirect_to).with('/')

    @handler.handle
  end  

  it "should save if handle is new and params valid" do
    handle = double
    params = { name: "Star", password: "pw"}
    @handler = PostHandleCreateCmd.new(params, @session, @server, @view_data)

    File.stub(:read).with('banned.txt') { "456\n789"}
    File.stub(:read).with('blacklist.txt') { "789"}

    Handle.should_receive(:new) { handle }     
    handle.should_receive(:create_from).with(params)
    handle.should_receive(:valid?) { true }
    handle.should_receive(:save!)
    handle.should_receive(:change_password).with("pw")
    
    @server.should_receive(:ip_addr) { "123" }
    @server.should_receive(:show_flash).with(:notice, "Handle created!  You can now log in and go to 'My Account' to set your preferences.")
    @server.should_receive(:redirect_to).with('/login')

    @handler.handle  
  end  
end