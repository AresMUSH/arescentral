class PostHandleCharResetPasswordCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle_id = @params[:handle_id]
    char_id = @params[:char_id]

    handle = HandleFinder.find(handle_id, @server)
    return if !handle
    return if !OwnerChecker.check(@server, handle)
    
    char = handle.linked_chars.select { |c| c.id.to_s == char_id }.first
    if (!char)
       @server.show_flash :error, "That character is not linked to your handle."
       @server.redirect_to "/handle/#{handle_id}/edit"
       return
     end
     
    temp_password = (0...8).map { (65 + rand(26)).chr }.join
    char.temp_password = temp_password
    char.save!
    
    @server.show_flash :notice, "Your temporary password is now #{temp_password}."
    @server.redirect_to "/handle/#{handle_id}/char/manage"
  end
end