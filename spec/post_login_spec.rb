require_relative 'test_helper'

describe PostLoginCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should show flash message and redirect if invalid handle" do
    @handler = PostLoginCmd.new({ handle: "h", password: "Y"}, @session, @server, @view_data)

    Handle.should_receive(:where).with({ :name_upcase => "H" }) { [] }      
    @server.should_receive(:show_flash).with(:error, "Invalid handle name or password.")
    @server.should_receive(:redirect_to).with('/login')

    @handler.handle
  end  

  it "should show flash and redirect if invalid password" do
    handle = double
    @handler = PostLoginCmd.new({ handle: "H", password: "Y"}, @session, @server, @view_data)
    
    Handle.stub(:where) { [ handle ] }

    handle.should_receive(:compare_password).with("Y") { false }
    @server.should_receive(:show_flash).with(:error, "Invalid handle name or password.")
    @server.should_receive(:redirect_to).with('/login')
    
    @handler.handle
  end
  
  it "should set session and log in if everything ok" do
    handle = double
    @handler = PostLoginCmd.new({ handle: "H", password: "Y"}, @session, @server, @view_data)

    Handle.stub(:where) { [ handle ] }
    handle.stub(:id) { 1 }
    
    handle.should_receive(:compare_password).with("Y") { true }
    @server.should_receive(:redirect_to).with('/')
    
    @handler.handle
    
    @session[:user_id].should eq 1
  end
  
end