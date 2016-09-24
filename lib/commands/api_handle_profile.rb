class ApiHandleProfileCmd
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
    
    { status: "success", data: { profile: handle.profile } }.to_json
  end
end


