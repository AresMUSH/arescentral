require_relative 'test_helper'

module AresCentral
  describe GamesIndexHandler do

    before do    
      @user = double
    end
    
    
    it "should put open+public games in the right categories and sorted" do
      handler = GamesIndexHandler.new(@user)
      
      # Public + Open = open
      game1 = double
      expect(game1).to receive(:name) { "A" }
      expect(game1).to receive(:category) { "H" }
      expect(game1).to receive(:summary_data) { "SUMMARY1" }
      expect(game1).to receive(:is_open?) { true }
      expect(game1).to receive(:is_public?) { true }
      expect(game1).to receive(:is_in_dev?) { false }
      expect(game1).to receive(:is_closed?) { false }
      
      game2 = double
      expect(game2).to receive(:name) { "B" }
      expect(game2).to receive(:category) { "G" }
      expect(game2).to receive(:summary_data) { "SUMMARY2" }
      expect(game2).to receive(:is_open?) { true }
      expect(game2).to receive(:is_public?) { true }
      expect(game2).to receive(:is_in_dev?) { false }
      expect(game2).to receive(:is_closed?) { false }
      
      game3 = double
      expect(game3).to receive(:name) { "C" }
      expect(game3).to receive(:category) { "H" }
      expect(game3).to receive(:summary_data) { "SUMMARY3" }
      expect(game3).to receive(:is_open?) { true }
      expect(game3).to receive(:is_public?) { true }
      expect(game3).to receive(:is_in_dev?) { false }
      expect(game3).to receive(:is_closed?) { false }

      
      expect(Game).to receive(:all) { [ game3, game2, game1 ]}

      # Ensure sorted by category then name
      handler.handle do |response|
        expect(response[:open]).to eq [ "SUMMARY2", "SUMMARY1", "SUMMARY3" ]
        expect(response[:dev]). to eq []
        expect(response[:closed]).to eq []
      end
        
    end
    
    it "should put public dev/closed games into the right categories" do
      handler = GamesIndexHandler.new(@user)
      
      game1 = double
      expect(game1).to receive(:name) { "A" }
      expect(game1).to receive(:category) { "H" }
      expect(game1).to receive(:summary_data) { "SUMMARY1" }
      expect(game1).to receive(:is_open?) { false }
      expect(game1).to receive(:is_public?) { true }
      expect(game1).to receive(:is_in_dev?) { true }
      expect(game1).to receive(:is_closed?) { false }
      
      game2 = double
      expect(game2).to receive(:name) { "B" }
      expect(game2).to receive(:category) { "G" }
      expect(game2).to receive(:summary_data) { "SUMMARY2" }
      expect(game2).to receive(:is_open?) { false }
      expect(game2).to receive(:is_public?) { true }
      expect(game2).to receive(:is_in_dev?) { true }
      expect(game2).to receive(:is_closed?) { false }
      
      game3 = double
      expect(game3).to receive(:name) { "C" }
      expect(game3).to receive(:summary_data) { "SUMMARY3" }
      expect(game3).to receive(:is_open?) { false }
      expect(game3).to receive(:is_public?) { true }
      expect(game3).to receive(:is_in_dev?) { false }
      expect(game3).to receive(:is_closed?) { true }

      
      expect(Game).to receive(:all) { [ game3, game2, game1 ]}

      # Ensure sorted by category then name
      handler.handle do |response|
        expect(response[:open]).to eq []
        expect(response[:dev]). to eq [ "SUMMARY2", "SUMMARY1" ]
        expect(response[:closed]).to eq [ "SUMMARY3" ]
      end
      
    end  
    
    it "should not include private games in any category" do
      handler = GamesIndexHandler.new(@user)
      
      game1 = double
      expect(game1).to receive(:is_public?) { false }
      
      expect(Game).to receive(:all) { [ game1 ]}

      handler.handle do |response|
        expect(response[:open]).to eq []
        expect(response[:dev]). to eq []
        expect(response[:closed]).to eq []
      end
      
    end  
  end
end