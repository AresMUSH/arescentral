require_relative 'test_helper'

module AresCentral
  describe UnlinkCharHandler do

    before do
      @user = double
    end
    
    it "should fail if user not logged in" do
      handler = UnlinkCharHandler.new(nil, {})
      expect { handler.handle }.to raise_exception(InsufficientPermissionError)
    end
    
    it "should fail if link not found" do
      handler = UnlinkCharHandler.new(@user, { "link_id" => "123" })
      link1 = double
      expect(link1).to receive(:id) { "234" }
      expect(@user).to receive(:linked_chars) { [ link1 ] }
      expect(link1).to_not receive(:update)
      
      expect { handler.handle }.to raise_exception(NotFoundError)
    end  
    
    it "should update link to retired" do
      handler = UnlinkCharHandler.new(@user, { "link_id" => "123" })
      link1 = double
      expect(link1).to receive(:id) { "123" }
      expect(@user).to receive(:linked_chars) { [ link1 ] }
      expect(link1).to receive(:update).with(retired: true)
      expect(@user).to receive(:all_linked_chars_data).with(@user) { "JSON_DATA" }
      response = { links: "JSON_DATA" }
      expect(handler.handle).to eq response
    end      
  end
end