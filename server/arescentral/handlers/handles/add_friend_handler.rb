module AresCentral
  class AddFriendHandler
    
    def initialize(user, params)
      @friend_id = params["friend_id"]
      @user = user
    end
    
    def handle
      
      if (!@user)
        raise InsufficientPermissionError.new
      end
      
      friend = Handle.find_by_name_or_id(@friend_id)
      if (!friend)
        raise NotFoundError.new
      end
            
      friendship = @user.friendships.select { |f| f.friend.id == friend.id }.first
      if (!friendship)
        Friendship.create(owner: @user, friend: friend)
        AresCentral.logger.info "#{@user.name} added #{friend.name} as a friend."
      end
            
      { 
        friends: @user.friends_data        
      }
      
    end
  end
end

    