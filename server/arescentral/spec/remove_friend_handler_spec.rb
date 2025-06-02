require_relative 'test_helper'

module AresCentral
  describe RemoveFriendHandler do

    before do
      @user = double
      allow(@user).to receive(:name) { "User" }
    end
    
    it "should fail if user not logged in" do
      handler = RemoveFriendHandler.new(nil, {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should fail if friend not found" do
      handler = RemoveFriendHandler.new(@user, {"friend_id" => "123" })
      expect(Handle).to receive(:find_by_name_or_id).with("123") { nil }
      expect(Friendship).to_not receive(:create)
      expect { handler.handle }.to raise_exception(NotFoundError)
    end  
    
    it "should do nothing but not fail if they're not friends" do
      handler = RemoveFriendHandler.new(@user, {"friend_id" => "123" })
      friend = double
      expect(Handle).to receive(:find_by_name_or_id).with("123") { friend }
      expect(@user).to receive(:friendships) { [] }
      expect(@user).to receive(:friends_data) { "FRIENDS" }
      result = { friends: "FRIENDS" }
      expect(handler.handle).to eq result
    end
    
    it "should remove a friend" do
      handler = RemoveFriendHandler.new(@user, {"friend_id" => "123" })
      friend = double
      friendship = double
      expect(friendship).to receive(:friend) { friend }
      expect(friend).to receive(:id) { "123" }.twice
      expect(@user).to receive(:friendships) { [ friendship ] }
      expect(Handle).to receive(:find_by_name_or_id).with("123") { friend }
      allow(friend).to receive(:name) { "Friend" }
      expect(friendship).to receive(:delete)
      expect(@user).to receive(:friends_data) { "FRIENDS" }
      result = { friends: "FRIENDS" }
      expect(handler.handle).to eq result
    end  
  end
end