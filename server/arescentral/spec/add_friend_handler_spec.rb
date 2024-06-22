require_relative 'test_helper'

module AresCentral
  describe AddFriendHandler do

    before do
      @user = double
      allow(@user).to receive(:name) { "User" }
    end
    
    it "should fail if user not logged in" do
      handler = AddFriendHandler.new(nil, {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should fail if friend not found" do
      handler = AddFriendHandler.new(@user, {"friend_id" => "123" })
      expect(Handle).to receive(:find_by_name_or_id).with("123") { nil }
      expect(Friendship).to_not receive(:create)
      expect { handler.handle }.to raise_exception(NotFoundError)
    end  
    
    it "should do nothing but not fail if they're already friends" do
      handler = AddFriendHandler.new(@user, {"friend_id" => "123" })
      friend = double
      expect(Handle).to receive(:find_by_name_or_id).with("123") { friend }
      expect(friend).to receive(:id) { "123" }.twice

      friendship = double
      expect(friendship).to receive(:friend) { friend }

      expect(@user).to receive(:friendships) { [ friendship ] }

      expect(Friendship).to_not receive(:create)
      expect(@user).to receive(:friends_data) { "FRIENDS" }

      result = { friends: "FRIENDS" }
      expect(handler.handle).to eq result
    end
    
    it "should create a friend" do
      handler = AddFriendHandler.new(@user, {"friend_id" => "123" })

      friend = double
      expect(Handle).to receive(:find_by_name_or_id).with("123") { friend }
      allow(friend).to receive(:name) { "Friend" }

      expect(@user).to receive(:friendships) { [] }

      expect(Friendship).to receive(:create) do |params|
        expect(params[:owner]).to eq @user
        expect(params[:friend]).to eq friend
      end
      expect(@user).to receive(:friends_data) { "FRIENDS" }

      result = { friends: "FRIENDS" }
      expect(handler.handle).to eq result
    end  
  end
end