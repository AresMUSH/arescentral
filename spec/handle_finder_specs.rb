require_relative 'test_helper'

describe HandleFinder do

  before do    
    @server = double
  end
    
  it "should show flash message and redirect handle not found" do
    Handle.should_receive(:find).with(123) { nil }      

    @server.should_receive(:show_flash).with(:error, "Handle not found.")
    @server.should_receive(:redirect_to).with('/handles')

    HandleFinder.find(123, @server)
  end  

  it "should return handle if found" do
    handle = double

    Handle.should_receive(:find).with(123) { handle }      
    @server.should_receive(:render_erb).with(:"handles/detail", :layout => :default)

    HandleFinder.find(123, @server).should eq handle
  end  
end