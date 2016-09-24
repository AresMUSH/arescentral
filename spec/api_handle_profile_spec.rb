require_relative 'test_helper'

describe ApiHandleProfileCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if the handle is not found" do
    @handler = ApiHandleProfileCmd.new({ handle_id: 123 }, @session, @server, @view_data)
    Handle.should_receive(:find).with(123) { nil }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "failure"
    response["error"].should eq "Handle not found."
  end  

  it "should return profile" do
    handle = double
    @handler = ApiHandleProfileCmd.new({ handle_id: 123 }, @session, @server, @view_data)
    
    Handle.should_receive(:find).with(123) { handle }
    handle.should_receive(:profile) { "A Profile" }

    response = JSON.parse(@handler.handle)
    response["status"].should eq "success"
    response["data"]["profile"].should eq "A Profile"    
  end 
end