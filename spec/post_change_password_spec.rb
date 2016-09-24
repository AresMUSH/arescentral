require_relative 'test_helper'

describe PostChangePasswordCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should show flash message and redirect if pw don't match" do
    @handler = PostChangePasswordCmd.new({ password: "h", confirm_password: "y" }, @session, @server, @view_data)

    @server.should_receive(:show_flash).with(:error, "Passwords don't match.")
    @server.should_receive(:redirect_to).with('/change-password')

    @handler.handle
  end  
  
  it "should reset password if everything ok" do
    handle = double
    @handler = PostChangePasswordCmd.new({ password: "h", confirm_password: "h" }, @session, @server, @view_data)

    @server.stub(:user) { handle } 
    handle.should_receive(:change_password)
    handle.should_receive(:save!)
    
    @server.should_receive(:show_flash).with(:notice, "Password changed.")
    @server.should_receive(:redirect_to).with('/')
    
    @handler.handle
  end
  
end