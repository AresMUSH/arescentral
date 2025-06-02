module AresCentral
  class GamesAdminHandler
        
    def initialize(user)
      @user = user
    end
    
    def handle
      authorized = @user && @user.is_admin?
      if (!authorized)
        raise InsufficientPermissionError.new
      end
      
      Game.all.to_a.sort_by { |g| g.name }.map { |g| g.summary_data }
    end
  end
end
