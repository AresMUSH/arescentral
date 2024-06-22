require_relative 'test_helper'

module AresCentral
  describe Plugin do
    
    describe :url_to_key do
      it "should fail for an invalid key" do
        
        expect(Plugin.url_to_key("ares-mytest-plugin")).to be_nil
        expect(Plugin.url_to_key("https://somewherelse/ares-mytest-plugin")).to be_nil
        expect(Plugin.url_to_key("https://github.com/Someone/mytest-plugin")).to be_nil
        expect(Plugin.url_to_key("https://github.com/Someone/ares-mytest")).to be_nil
        expect(Plugin.url_to_key("https://github.com/Someone/mytest" )).to be_nil
      end
      
      it "should accept a valid url" do
        expect(Plugin.url_to_key("https://github.com/Someone/ares-mytest-plugin")).to eq "mytest"
        
      end
    end
  end
  
end
