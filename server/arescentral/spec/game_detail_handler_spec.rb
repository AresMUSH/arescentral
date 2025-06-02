require_relative 'test_helper'

module AresCentral
  describe GameDetailHandler do

    before do    
      @user = double
      @game = double
    end
    
    it "should fail if game not found" do
      @handler = GameDetailHandler.new(@user, { game_id: 123})
      expect(Game).to receive(:[]).with(123) { nil }    
      expect { @handler.handle }.to raise_exception(NotFoundError)
    end  
    
    it "should fail if player can't see game" do
      @handler = GameDetailHandler.new(@user, { game_id: 123})
      expect(Game).to receive(:[]).with(123) { @game }    
      expect(@game).to receive(:can_view_game?).with(@user) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end  


    it "should return game data if player can see game" do
      @handler = GameDetailHandler.new(@user, { game_id: 123})
      expect(Game).to receive(:[]).with(123) { @game }    
      expect(@game).to receive(:can_view_game?).with(@user) { true }
      expect(@game).to receive(:detail_data) { "JSON DATA" }
      expect(@handler.handle).to eq "JSON DATA"
    end  

  end
end