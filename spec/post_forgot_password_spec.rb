require_relative 'test_helper'

describe PostForgotPasswordCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should show flash message and redirect if invalid handle" do
    @handler = PostForgotPasswordCmd.new({ email: "h" }, @session, @server, @view_data)

    Handle.should_receive(:where).with({ :email => "h" }) { [] }      
    @server.should_receive(:show_flash).with(:notice, "If that email is in our records, a new password will be sent to it.")
    @server.should_receive(:redirect_to).with('/')

    @handler.handle
  end  
  
  it "should reset password if everything ok" do
    handle = double
    @handler = PostForgotPasswordCmd.new({ email: "h" }, @session, @server, @view_data)

    Handle.should_receive(:where).with({ :email => "h" }) { [handle] }      
    handle.should_receive(:change_password)
    handle.should_receive(:save!)
    handle.stub(:email) { "h" }
    MailHelper.should_receive(:send) {}
    
    @server.should_receive(:show_flash).with(:notice, "If that email is in our records, a new password will be sent to it.")
    @server.should_receive(:redirect_to).with('/')
    
    @handler.handle
  end
  
end