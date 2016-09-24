require_relative 'test_helper'

describe GetGameDetailCmd do

  before do    
    @server = double
    @session = {}
    @view_data = {}
  end
    
  it "should fail if game not found" do
    @handler = GetGameDetailCmd.new({ game_id: 123}, @session, @server, @view_data)
    Game.should_receive(:find).with(123) { nil }
    @server.should_receive(:show_flash).with(:error, "Game not found.")
    @server.should_receive(:redirect_to).with("/games")
    @handler.handle
  end  

  it "should render template if handle found" do
    game = double
    @handler = GetGameDetailCmd.new({ game_id: 123}, @session, @server, @view_data)

    Game.should_receive(:find).with(123) { game }
    @server.should_receive(:render_erb).with(:"games/detail", :layout => :default)

    @handler.handle
    
    @view_data[:game].should eq game
  end  
end