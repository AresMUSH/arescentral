require_relative 'test_helper'

module AresCentral
  describe BanPlayerHandler do

    before do    
      @user = double
    end
    
    it "should fail if user is not admin" do
      @handler = BanPlayerHandler.new(@user, {}, false)
      expect(@user).to receive(:is_admin?) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end  
    
    it "should fail if handle not found" do
      @handler = BanPlayerHandler.new(@user, { "handle_id" => "123" }, true)
      expect(@user).to receive(:is_admin?) { true }
      
      expect(Handle).to receive(:find_by_name_or_id).with("123") { nil }
      
      err = { error: "Handle not found." }
      expect(@handler.handle).to eq err
    end  
    
    it "should ban a player if specified" do
      @handler = BanPlayerHandler.new(@user, { "handle_id" => "123" }, true)
      expect(@user).to receive(:is_admin?) { true }
      
      handle = double
      expect(Handle).to receive(:find_by_name_or_id).with("123") { handle }
      expect(handle).to receive(:update).with({forum_banned: true})
      allow(handle).to receive(:name) { "Bob" }
      allow(@user).to receive(:name) { "Faraday" }
      response = {}
      expect(@handler.handle).to eq response
    end  
    
    it "should un-ban a player if specified" do
      @handler = BanPlayerHandler.new(@user, { "handle_id" => "123" }, false)
      expect(@user).to receive(:is_admin?) { true }
      
      handle = double
      expect(Handle).to receive(:find_by_name_or_id).with("123") { handle }
      expect(handle).to receive(:update).with({forum_banned: false})
      allow(handle).to receive(:name) { "Bob" }
      allow(@user).to receive(:name) { "Faraday" }
      response = {}
      expect(@handler.handle).to eq response
    end  
  end
end