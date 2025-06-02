module AresCentral
  class ApiPluginRegisterCmd
    def initialize(params)
      @name = params["name"]
    end
  
    def handle
      # DEPRECATED - plugins are now tracked via game registration
    
      { status: "success", data: {} }.to_json
    end
  end
end