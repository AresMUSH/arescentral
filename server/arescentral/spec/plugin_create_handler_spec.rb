require_relative 'test_helper'

module AresCentral
  describe PluginCreateHandler do

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
      allow(@user).to receive(:is_admin?) { true }      
      allow(Plugin).to receive(:url_to_key) { "mytest" }
    end
    
    it "should fail if user is not admin" do
      @handler = PluginCreateHandler.new(@user, {})
      expect(@user).to receive(:is_admin?) { false }
      expect { @handler.handle }.to raise_exception(InsufficientPermissionError)
    end      
    
    it "should fail if missing parameters" do
      PluginCreateHandler.required_fields.each do |field|
         @handler = PluginCreateHandler.new(@user, @params.select { |k, v| k != field })
         err = { error: "Missing required field #{field}." }
         expect(@handler.handle).to eq err
       end
    end  
    
    it "should fail if URL is not the right format" do
      @handler = PluginCreateHandler.new(@user, @params)
      expect(Plugin).to receive(:url_to_key).with("https://github.com/Someone/ares-mytest-plugin") { nil }
      err = { error: "GitHub URL not compatible with installer." }
      expect(@handler.handle).to eq err
    end     
    
    it "should fail if author not found" do
      expect(Handle).to receive(:find_by_name).with("Faraday") { nil }
      
      @handler = PluginCreateHandler.new(@user, @params)
      err = { error: "Author not found." }
      expect(@handler.handle).to eq err
    end  
    
    it "should fail if plugin already exists" do
      handle = double
      expect(Handle).to receive(:find_by_name).with("Faraday") { handle }
      
      existing_plugin = double
      expect(existing_plugin).to receive(:keyname) { "mytest" }
      expect(Plugin).to receive(:all) { [existing_plugin] }
      
      @handler = PluginCreateHandler.new(@user, @params)
      err = { error: "Plugin mytest already exists." }
      expect(@handler.handle).to eq err
    end  
    
    it "should create the plugin" do
      handle = double
      expect(Handle).to receive(:find_by_name).with("Faraday") { handle }
      expect(Plugin).to receive(:all) { [] }
      
      @handler = PluginCreateHandler.new(@user, @params)

      plugin = double
      allow(plugin).to receive(:id) { 12 }
      
      create_params = {
        name: "Test Plugin",
        key: "mytest",
        description: "A test plugin.",
        url: "https://github.com/Someone/ares-mytest-plugin",
        custom_code: "Yes",
        web_portal: "None",
        category: "Building",
        installs: 0,
        handle: handle
      }
      expect(Plugin).to receive(:create).with(create_params) { plugin }

      response = { id: 12 }
      expect(@handler.handle).to eq response
    end  
    
  end
end