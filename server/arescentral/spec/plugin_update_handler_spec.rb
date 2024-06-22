require_relative 'test_helper'

module AresCentral
  describe PluginUpdateHandler do

    before do    
      @user = double
      @params = {
        "author_name" => "Faraday",
        "name" => "Test Plugin",
        "description" => "A test plugin.",
        "url" => "https://github.com/Someone/ares-mytest-plugin",
        "category" => "Building",
        "custom_code" => true,
        "web_portal" => false
      }
      allow(Plugin).to receive(:url_to_key) { "mytest" }
      allow(@user).to receive(:is_admin?) { true }      
    end
    
    it "should fail if user is not admin" do
      @handler = PluginUpdateHandler.new(@user, "111", {})
      expect(@user).to receive(:is_admin?) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end  
    
    it "should fail if missing parameters" do
      PluginUpdateHandler.required_fields.each do |field|
         @handler = PluginUpdateHandler.new(@user, { "plugin_id" => "111" }, @params.select { |k, v| k != field })
         err = { error: "Missing required field #{field}." }
         expect(@handler.handle).to eq err
       end
    end  
    
    it "should fail if URL is not the right format" do
      plugin = double
      expect(Plugin).to receive(:[]).with("111") { plugin }

      @handler = PluginUpdateHandler.new(@user, { "plugin_id" => "111" }, @params)
      expect(Plugin).to receive(:url_to_key).with("https://github.com/Someone/ares-mytest-plugin") { nil }
      err = { error: "GitHub URL not compatible with installer." }
      expect(@handler.handle).to eq err
    end  
    
    it "should fail if author not found" do
      plugin = double
      expect(Plugin).to receive(:[]).with("111") { plugin }

      expect(Handle).to receive(:find_by_name).with("Faraday") { nil }
      
      @handler = PluginUpdateHandler.new(@user, { "plugin_id" => "111" }, @params)
      err = { error: "Author not found." }
      expect(@handler.handle).to eq err
    end  
    
    it "should fail if a different plugin with same key already exists" do
      plugin = double
      expect(Plugin).to receive(:[]).with("111") { plugin }
      
      handle = double
      expect(Handle).to receive(:find_by_name).with("Faraday") { handle }
      
      existing_plugin = double
      expect(existing_plugin).to receive(:keyname) { "mytest" }
      expect(Plugin).to receive(:all) { [existing_plugin] }
      
      @handler = PluginUpdateHandler.new(@user, { "plugin_id" => "111" }, @params)
      err = { error: "Plugin mytest already exists." }
      expect(@handler.handle).to eq err
    end  
    
    it "should update the plugin" do
      handle = double
      expect(Handle).to receive(:find_by_name).with("Faraday") { handle }
      @handler = PluginUpdateHandler.new(@user, { "plugin_id" => "111" }, @params)

      plugin = double
      expect(Plugin).to receive(:[]).with("111") { plugin }
      allow(plugin).to receive(:id) { 12 }
      expect(Plugin).to receive(:all) { [] }
      
      update_params = {
        name: "Test Plugin",
        keyname: "mytest",
        description: "A test plugin.",
        url: "https://github.com/Someone/ares-mytest-plugin",
        custom_code: "Yes",
        web_portal: "None",
        category: "Building",
        installs: 0,
        handle: handle
      }
      expect(plugin).to receive(:update).with(update_params) { plugin }

      response = { id: 12 }
      expect(@handler.handle).to eq response
    end  
    
  end
end