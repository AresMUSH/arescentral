module AresCentral
  class GamesOrphansHandler
        
    def initialize(user)
      @user = user
    end
    
    def handle
      authorized = @user && @user.is_admin?
      if (!authorized)
        raise InsufficientPermissionError.new
      end
            
      down_ares_games = Game.all
                      .select { |g| !g.is_up? && !g.aressub_retired && g.host.include?("aresmush.com")}
                      .sort_by { |g| [g.host, g.name] }
                      .map { |g| g.summary_data }
      
      down_ares_games
    end
  end
end
