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
    
    describe :install_count do 
      it "should count games using the plugin" do
        game1 = double
        expect(game1).to receive(:uses_plugin?).with("A") { true }
        expect(game1).to receive(:uses_plugin?).with("B") { false }
        expect(game1).to receive(:uses_plugin?).with("C") { false }
        game2 = double
        expect(game2).to receive(:uses_plugin?).with("A") { true }
        expect(game2).to receive(:uses_plugin?).with("B") { true }
        expect(game2).to receive(:uses_plugin?).with("C") { false }
        expect(Game).to receive(:all) { [ game1, game2 ]}.exactly(3)
        
        a = Plugin.new(keyname: "A")
        expect(a.install_count).to eq 2

        b = Plugin.new(keyname: "B")
        expect(b.install_count).to eq 1

        c = Plugin.new(keyname: "C")
        expect(c.install_count).to eq 0        
      end
      
      it "should include preexisting installs" do
        game1 = double
        expect(game1).to receive(:uses_plugin?).with("A") { true }
        expect(game1).to receive(:uses_plugin?).with("B") { false }
        game2 = double
        expect(game2).to receive(:uses_plugin?).with("A") { true }
        expect(game2).to receive(:uses_plugin?).with("B") { true }
        expect(Game).to receive(:all) { [ game1, game2 ]}.twice
        
        a = Plugin.new(keyname: "A", installs: 0)
        expect(a.install_count).to eq 2

        b = Plugin.new(keyname: "B", installs: 4)
        expect(b.install_count).to eq 5
      end
    end
    
  end
  
end
