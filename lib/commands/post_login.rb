class PostLoginCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    user = @params[:handle]
    pw = @params[:password]
    handle = Handle.where(name_upcase: user.upcase).first
    if (handle && handle.compare_password(pw))
      @session[:user_id] = handle.id
      @server.redirect_to '/'
      return
    end

    @server.show_flash :error, "Invalid handle name or password."
    @server.redirect_to '/login'
  end
end