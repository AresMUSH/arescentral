class GetPluginDetailCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    plugin = Plugin.find(@params[:plugin_id])
    if (!plugin)
      @server.show_flash :error, "Plugin not found."
      @server.redirect_to "/plugins"
      return
    end
      
    @view_data[:plugin] = plugin
    @server.render_erb :"plugins/detail", :layout => :default
  end
end


