module AresCentral
  class GamesStatsHandler
        
    def initialize(user)
      @user = user
    end
    
    def handle
      authorized = @user && @user.is_admin?
      if (!authorized)
        raise InsufficientPermissionError.new
      end
      
      games = Game.all
      
      {
        total_handles: Handle.all.count,
        total_games: games.count,
        open_games: games.select { |g| g.report_status == "open" }.count,
        dev_games: games.select { |g| g.report_status == "dev" }.count,
        private_games: games.select { |g| g.report_status == "private" }.count,
        closed_games: games.select { |g| g.report_status == "closed" }.count
      }
    end
  end
end
