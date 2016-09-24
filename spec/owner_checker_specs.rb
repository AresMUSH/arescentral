require_relative 'test_helper'

describe OwnerChecker do

  before do    
    @server = double
    @user = double
    @server.should_receive(:user) { @user }
  end
    
  it "should show flash message and redirect handle is not user" do
    
    @server.should_receive(:show_flash).with(:error, "Handle not found.")
    @server.should_receive(:redirect_to).with('/handles')

    OwnerChecker.check(@server, double).should be_false
  end  

  it "should return handle if found" do
    OwnerChecker.check(@server, @user).should be_true    
  end  
end