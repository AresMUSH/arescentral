class ApiHandleFriendsCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle = Handle.find @params[:handle_id]
    if (!handle)
      return { status: "failure", error: "Handle not found." }.to_json
    end
    
    data = {
      friends: handle.friends.map { |f| f.name }
    }
    
    { status: "success", data: data }.to_json
  end
end


