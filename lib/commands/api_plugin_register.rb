class ApiPluginRegisterCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    name = @params[:name]
    plugin = Plugin.all.select { |p| p.key == (name || "").downcase }.first
    if (!plugin)
      return { status: "failure", error: "Plugin #{name} not found." }.to_json
    end
    
    plugin.installs = plugin.installs + 1
    plugin.save!
    
    { status: "success", data: {} }.to_json
  end
end