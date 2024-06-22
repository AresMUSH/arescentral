require_relative 'test_helper'

module AresCentral
  describe UpdateGameStatusHandler do

    before do    
      @user = double
    end
    
    it "should fail if user is not admin" do
      @handler = UpdateGameStatusHandler.new(@user, {}, {})
      expect(@user).to receive(:is_admin?) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end  
    
    it "should fail if game not found" do
      @handler = UpdateGameStatusHandler.new(@user, { "game_id" => "123" }, {})
      expect(@user).to receive(:is_admin?) { true }
      
      expect(Game).to receive(:[]).with("123") { nil }
      
      err = { error: "Game not found." }
      expect(@handler.handle).to eq err
    end  
    
    it "should fail if game status is not valid" do
      @handler = UpdateGameStatusHandler.new(@user, { "game_id" => "123" }, { "status" => "x" })
      expect(@user).to receive(:is_admin?) { true }
      
      game = double
      expect(Game).to receive(:[]).with("123") { game }
      expect(game).to_not receive(:update)
      
      err = { error: "Invalid status." }
      expect(@handler.handle).to eq err
    end  
    
    it "should update the game" do
      @handler = UpdateGameStatusHandler.new(@user, { "game_id" => "123" }, { "status" => "Beta", "is_public" => true })
      expect(@user).to receive(:is_admin?) { true }
      
      game = double
      allow(game).to receive(:name) { "BSGU" }
      allow(@user).to receive(:name) { "Jack" }
      expect(Game).to receive(:[]).with("123") { game }
      expect(game).to receive(:update).with(status: "Beta")
      expect(game).to receive(:update).with(public_game: true)
      response = {}
      expect(@handler.handle).to eq response
    end  
    
  end
end