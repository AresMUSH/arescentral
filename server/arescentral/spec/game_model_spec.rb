require_relative 'test_helper'

module AresCentral
  describe Game do

    before do
      @game = Game.new
    end
    
    describe :address do
      it "should return host if website nil" do
        @game.host = "somewhere.com"
        @game.website = nil
        expect(@game.address).to eq "http://somewhere.com"
      end

      it "should return host if website blank" do
        @game.host = "somewhere.com"
        @game.website = ""
        expect(@game.address).to eq "http://somewhere.com"
      end

      it "should return website if set" do
        @game.host = "somewhereelse.com"
        @game.website = "https://somewhere.com"
        expect(@game.address).to eq "https://somewhere.com"
      end
      
      it "should add http to website if missing" do
        @game.host = "somewhereelse.com"
        @game.website = "somewhere.com"
        expect(@game.address).to eq "http://somewhere.com"
      end
      
    end
      
    describe :can_view_game? do
      before do
        @game = Game.new
        @handle = double
      end
        
      it "should return true if game is public" do
        @game.public_game = true
        expect(@game.can_view_game?(@handle)).to eq true
      end
      
      it "should return true for private game if char is admin" do
        @game.public_game = false
        expect(@handle).to receive(:is_admin) { true }
        expect(@game.can_view_game?(@handle)).to eq true
      end
      
      it "should return false for private game if char is not an admin but has a char" do
        @game.public_game = false
        expect(@handle).to receive(:is_admin) { false }
        expect(@handle).to receive(:has_char_on_game?).with(@game) { true }
        expect(@game.can_view_game?(@handle)).to eq true
      end

      it "should return false for private game if char is not an admin and has no char" do
        @game.public_game = false
        expect(@handle).to receive(:is_admin) { false }
        expect(@handle).to receive(:has_char_on_game?).with(@game) { false }
        expect(@game.can_view_game?(@handle)).to eq false
      end
      
    end
    
    describe :average_logins do
      before do
        @game = Game.new        
      end
        
      it "should not die if activity is nil" do
        @game.activity =  nil
        expect(@game.average_logins(0, 0)).to eq 0
      end
      
      it "should not die if activity is empty" do
        @game.activity =  {}
        expect(@game.average_logins(0, 0)).to eq 0
      end
      
      it "should average logins for the selected day and time" do
        @game.activity =  {
          "0" => {
            "0" => [ 1, 1, 1, 5, 5, 5],
            "1" => [ 2, 2, 2, 6, 6, 6]            
          },
          "1" => {
            "2" => [ 6, 6, 6, 8, 8, 8 ]
          }
        }
        expect(@game.average_logins(0, 0)).to eq 3
        expect(@game.average_logins(0, 1)).to eq 4
        expect(@game.average_logins(0, 2)).to eq 0
        expect(@game.average_logins(1, 0)).to eq 0
        expect(@game.average_logins(1, 2)).to eq 7
      end
      
    end
    
    describe :average_activity_table do
      before do
        @game = Game.new        
      end      
      
      it "should build an activity table from the data" do
        @game.activity =  {
          "0" => {
            "0" => [ 1, 1, 1, 5, 5, 5],
            "1" => [ 2, 2, 2, 6, 6, 6]            
          },
          "1" => {
            "2" => [ 6, 6, 6, 8, 8, 8 ]
          }
        }
        table = @game.average_activity_table
        expect(table["Sun"]["12-3am"]).to eq 0.6 # 3/5
        expect(table["Sun"]["4-7am"]).to eq 0.8  # 4/5
        expect(table["Sun"]["8-11am"]).to eq 0
        expect(table["Mon"]["12-3am"]).to eq 0
        expect(table["Mon"]["8-11am"]).to eq 1.4 # 7/5
      end
      
      it "should fill out all days and times" do
        allow(@game).to receive(:average_logins) do |day, time|
          day * time * 5 # x5 because we'll divide by 5 for the stars
        end
        
        table = @game.average_activity_table
        Game.activity_days.each_with_index do |day, day_index|
          Game.activity_times.each_with_index do |time, time_index|
            expect(table[day][time]).to eq day_index * time_index
          end
        end
      end
      
    end


    describe :is_replayed? do
      before do
        @game = Game.new
        handle1 = double
        allow(handle1).to receive(:name) { "Handle1" }
        handle2 = double
        allow(handle2).to receive(:name) { "Handle2" }
        handle3 = double
        allow(handle3).to receive(:name) { "Handle3" }
        handle4 = double
        allow(handle4).to receive(:name) { "Handle4" }
        
        # Cap played by 2 different people
        link1 = double
        allow(link1).to receive(:name) { "Cap" }
        allow(link1).to receive(:handle) { handle1 }

        link2 = double
        allow(link2).to receive(:name) { "Cap" }
        allow(link2).to receive(:handle) { handle2 }
        allow(link2).to receive(:retired) { true }
        
        # Thor played by 1 person
        link3 = double
        allow(link3).to receive(:name) { "Thor" }
        allow(link3).to receive(:handle) { handle3 }
        
        
        # Peggy played by the same person twice
        link4 = double
        allow(link4).to receive(:name) { "Peggy" }
        allow(link4).to receive(:handle) { handle4 }
        
        link5 = double
        allow(link5).to receive(:name) { "Peggy" }
        allow(link5).to receive(:handle) { handle4 }
        allow(link2).to receive(:retired) { true }
        
        allow(@game).to receive(:linked_chars) { [ link1, link2, link3, link4, link5 ] }
      end      
      
      it "should count a char who has had mult players" do
        expect(@game.is_replayed?("Cap", "Handle1")).to eq true
        expect(@game.is_replayed?("Cap", "Handle2")).to eq true
      end
      
      it "should not count a char who has had only one player xxx" do
        expect(@game.is_replayed?("Thor", "Handle3")).to eq false
      end
      
      it "should not count a char who has been played only by the same person" do
        expect(@game.is_replayed?("Peggy", "Handle4")).to eq false
      end
      
    end
    
    describe :create_or_update_linked_char do
      before do
        @game = Game.new
        allow(@game).to receive(:name) { "Test Game" }
      end

      it "should handle brand new link" do
        new_link = double
        handle = double
        allow(handle).to receive(:name) { "Faraday" }
        
        expect(@game).to receive(:linked_chars) { []}
        expect(LinkedChar).to receive(:create).with(name: "Harvey", handle: handle, game: @game, char_id: 789) { new_link }
    
        expect(@game.create_or_update_linked_char("Harvey", 789, handle)).to eq new_link
      end 
            
      it "should be okay if handle linked to different char on same game" do
        other_link = double
        new_link = double
        handle = double
        allow(handle).to receive(:name) { "Faraday" }
        
        expect(@game).to receive(:linked_chars) { [ other_link ]}
        allow(other_link).to receive(:name) { "Andrew" }
        allow(other_link).to receive(:char_id) { 700 }
        allow(other_link).to receive(:game) { @game }
    
        expect(LinkedChar).to receive(:create).with(name: "Harvey", handle: handle, game: @game, char_id: 789) { new_link }
    
        expect(@game.create_or_update_linked_char("Harvey", 789, handle)).to eq new_link
      end 
      
      it "should be okay if someone else has a different char link on same game" do
        other_link = double
        other_handle = double
        
        new_link = double
        handle = double
        allow(handle).to receive(:name) { "Faraday" }
        
        expect(@game).to receive(:linked_chars) { [ other_link ]}
        allow(other_link).to receive(:name) { "Andrew" }
        allow(other_link).to receive(:char_id) { 700 }
        allow(other_link).to receive(:game) { @game }
        allow(other_link).to receive(:handle) { other_handle }
    
        expect(LinkedChar).to receive(:create).with(name: "Harvey", handle: handle, game: @game, char_id: 789) { new_link }
    
        expect(@game.create_or_update_linked_char("Harvey", 789, handle)).to eq new_link
      end 
    
      it "should update retired status for same char on same game played by someone else" do
        other_link = double
        other_handle = double
        
        new_link = double
        handle = double
        allow(handle).to receive(:name) { "Faraday" }
        
        expect(@game).to receive(:linked_chars) { [ other_link ]}
        allow(other_link).to receive(:id) { "19" }
        allow(other_link).to receive(:name) { "Harvey" }
        allow(other_link).to receive(:char_id) { 789 }
        allow(other_link).to receive(:game) { @game }
        allow(other_link).to receive(:handle) { other_handle }
    
        expect(LinkedChar).to receive(:create).with(name: "Harvey", handle: handle, game: @game, char_id: 789) { new_link }
        expect(other_link).to receive(:update).with(retired: true)
        expect(other_link).to receive(:update).with(char_id: 789)
        
        expect(@game.create_or_update_linked_char("Harvey", 789, handle)).to eq new_link
      end 
    
      it "should update retired status for same char on same game played by same player" do
        existing_link = double
        handle = double
        allow(handle).to receive(:name) { "Faraday" }
        
        expect(@game).to receive(:linked_chars) { [ existing_link ]}
        allow(existing_link).to receive(:name) { "Harvey" }
        allow(existing_link).to receive(:id) { "19" }
        allow(existing_link).to receive(:char_id) { nil }
        allow(existing_link).to receive(:game) { @game }
        allow(existing_link).to receive(:handle) { handle }
        expect(existing_link).to receive(:update).with(char_id: 789)
    
        expect(LinkedChar).to_not receive(:create)
        expect(existing_link).to receive(:update).with(retired: false)
        
        expect(@game.create_or_update_linked_char("Harvey", 789, handle)).to eq existing_link
      end 
      
      it "should not update char ID if not provided" do
        existing_link = double
        handle = double
        allow(handle).to receive(:name) { "Faraday" }
        
        expect(@game).to receive(:linked_chars) { [ existing_link ]}
        allow(existing_link).to receive(:name) { "Harvey" }
        allow(existing_link).to receive(:char_id) { nil }
        allow(existing_link).to receive(:game) { @game }
        allow(existing_link).to receive(:handle) { handle }
    
        expect(LinkedChar).to_not receive(:create)
        expect(existing_link).to receive(:update) do |values|
          expect(values[:retired]).to eq false
          expect(values[:char_id]).to eq nil
        end
        
        expect(@game.create_or_update_linked_char("Harvey", "", handle)).to eq existing_link
      end 
    end
    
    describe :is_recently_updated do
      it "should not count a game that was updated more than 14 days ago" do
        @game.last_status_update = Time.new(2024, 01, 27)
        @game.created_at = Time.new(2023, 01, 27)
        
        expect(@game.is_recently_updated).to eq false
      end
      
      it "should not count a game that was created more than 14 days ago" do
        @game.last_status_update = nil
        @game.created_at = Time.new(2024, 01, 27)
        
        expect(@game.is_recently_updated).to eq false
      end
      
      it "should count a game that was updated less than 30 days ago" do
        @game.last_status_update = Time.now - (29 * 86400)
        @game.created_at = Time.new(2024, 01, 27)
        
        expect(@game.is_recently_updated).to eq true
      end
    end 
    
    describe :is_active do
      it "should count a game that has a high activity rating" do
        allow(@game).to receive(:activity_rating) { 2 }
        allow(@game).to receive(:is_recently_updated) { false }
        allow(@game).to receive(:up_status) { "Up" }
        allow(@game).to receive(:status) { "Open" }
        
        expect(@game.is_active?).to eq true
      end

      it "should count a game that has a low activity rating but was recently updated" do
        allow(@game).to receive(:activity_rating) { 1 }
        allow(@game).to receive(:is_recently_updated) { true }
        allow(@game).to receive(:up_status) { "Up" }
        allow(@game).to receive(:status) { "Open" }

        expect(@game.is_active?).to eq true
      end

      it "should not count a game that was not active and not recently updated" do
        allow(@game).to receive(:activity_rating) { 1 }
        allow(@game).to receive(:is_recently_updated) { false }
        allow(@game).to receive(:up_status) { "Up" }
        allow(@game).to receive(:status) { "Open" }

        expect(@game.is_active?).to eq false
      end 
      
      it "should not count closed games" do
        allow(@game).to receive(:activity_rating) { 2 }
        allow(@game).to receive(:is_recently_updated) { true }
        allow(@game).to receive(:up_status) { "Up" }
        allow(@game).to receive(:status) { "Closed" }

        expect(@game.is_active?).to eq false
      end   
      
      it "should not count down games" do
        allow(@game).to receive(:activity_rating) { 2 }
        allow(@game).to receive(:is_recently_updated) { true }
        allow(@game).to receive(:up_status) { "Down" }
        allow(@game).to receive(:status) { "Open" }

        expect(@game.is_active?).to eq false
      end      
      
    end     
  end
end