module AresCentral
  class ApiPluginRegisterCmd
    def initialize(params)
      @name = params["name"]
    end
  
    def handle
      plugin = Plugin.all.select { |p| p.keyname == (name || "").downcase }.first
      if (!plugin)
        return { status: "failure", error: "Plugin #{name} not found." }.to_json
      end
    
      plugin.update(installs: plugin.installs + 1)
    
      { status: "success", data: {} }.to_json
    end
  end
end