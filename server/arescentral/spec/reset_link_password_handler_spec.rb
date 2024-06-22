require_relative 'test_helper'

module AresCentral
  describe ResetLinkPasswordHandler do

    before do
      @user = double
    end
    
    it "should fail if user not logged in" do
      handler = ResetLinkPasswordHandler.new(nil, {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should fail if link not found" do
      handler = ResetLinkPasswordHandler.new(@user, { "link_id" => "123" })
      link1 = double
      expect(link1).to receive(:id) { "234" }
      expect(@user).to receive(:linked_chars) { [ link1 ] }
      expect(link1).to_not receive(:update)
      
      expect { handler.handle }.to raise_exception(NotFoundError)
    end  
    
    it "should update link password" do
      handler = ResetLinkPasswordHandler.new(@user, { "link_id" => "123" })
      link1 = double
      expect(link1).to receive(:id) { "123" }
      expect(@user).to receive(:linked_chars) { [ link1 ] }
      expect(Handle).to receive(:random_password) { "NEW_PW" }
      expect(link1).to receive(:update).with(temp_password: "NEW_PW")
      expect(@user).to receive(:all_linked_chars_data).with(@user) { "LINK_DATA" }
      response = { links: "LINK_DATA" }
      expect(handler.handle).to eq response
    end      
  end
end