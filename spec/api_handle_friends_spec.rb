require_relative 'test_helper'

describe ApiHandleFriendsCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if the handle is not found" do
    @handler = ApiHandleFriendsCmd.new({ handle_id: 123 }, @session, @server, @view_data)
    Handle.should_receive(:find).with(123) { nil }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Handle not found."
  end  

  it "should return friends" do
    handle = double
    @handler = ApiHandleFriendsCmd.new({ handle_id: 123 }, @session, @server, @view_data)
    f1 = double
    f2 = double
    
    Handle.should_receive(:find).with(123) { handle }
    handle.should_receive(:friends) { [ f1, f2 ] }

    f1.stub(:name) { "F1" }
    f2.stub(:name) { "F2" }
    
    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
    response["data"]["friends"].should eq [ "F1", "F2" ]
  end 
end