require_relative 'test_helper'

module AresCentral
  describe GamesAdminHandler do

    before do    
      @user = double
    end
    
    it "should fail if user is not admin" do
      @handler = GamesAdminHandler.new(@user)
      expect(@user).to receive(:is_admin?) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end  
    
    it "should return the summary for all games" do
      @handler = GamesAdminHandler.new(@user)
      expect(@user).to receive(:is_admin?) { true }
      
      game1 = double
      expect(game1).to receive(:name) { "A" }
      expect(game1).to receive(:summary_data) { "SUMMARY1" }

      game2 = double
      expect(game2).to receive(:name) { "B" }
      expect(game2).to receive(:summary_data) { "SUMMARY2" }

      expect(Game).to receive(:all) { [ game2, game1 ]}
      
      # Ensure sorted by name
      expect(@handler.handle).to eq [ "SUMMARY1", "SUMMARY2" ]
    end  
  end
end