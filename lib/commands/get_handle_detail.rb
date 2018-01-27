class GetHandleDetailCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    
    if (@params[:handle_id])
      handle = HandleFinder.find(@params[:handle_id], @server)
    else
      handle = HandleFinder.find_by_name(@params[:handle_name], @server)
    end
    return if !handle
    
    @view_data[:handle] = handle
    @server.render_erb :"handles/detail", :layout => :default
  end
end


