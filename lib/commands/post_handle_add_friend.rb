class PostHandleAddFriendCmd
  def initialize(params, session, server, view_data)
    @params = params
    @session = session
    @server = server
    @view_data = view_data
  end
  
  def handle
    handle_id = @params[:handle_id]
    friend_id = @params[:friend_id]
    
    handle = HandleFinder.find(handle_id, @server)
    return if !handle
    return if !OwnerChecker.check(@server, handle)
    
    friend = Handle.find(friend_id)
    if (!friend)
      @server.show_flash :error, "Friend not found."
      @server.redirect_to "/handle/#{handle_id}/edit"
      return
    end
      
    if (handle.friends.include?(friend))
      @server.show_flash :error, "They are already your friend."
      @server.redirect_to "/handle/#{handle_id}/edit"
      return
    end
    
    @server.show_flash :notice, "Friend added!"
    Friendship.create(owner: handle, friend: friend)
    @server.redirect_to "/handle/#{handle_id}/edit"
    
  end
end


