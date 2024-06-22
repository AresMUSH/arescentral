module AresCentral
  class GetFriendsHandler
    
    def initialize(user)
      @user = user
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end      
        
      { 
        friends: @user.friends_data,
        handles: Handle.all.map { |h| {
          id: h.id,
          name: h.name
        }}
      }
    end
  end
end

    