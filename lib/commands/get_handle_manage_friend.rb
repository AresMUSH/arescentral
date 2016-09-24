class GetHandleManageFriendCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle = HandleFinder.find(@params[:handle_id], @server)
    return if !handle
    return if !OwnerChecker.check(@server, handle)
    
    @view_data[:handles] = Handle.all
    @view_data[:handle] = handle
    @server.render_erb :"handles/manage-friend", :layout => :default
  end
end


