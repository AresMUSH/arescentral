module AresCentral
  class GamesIndexHandler
        
    def initialize(user)
      @user = user
    end
    
    def handle
      games = Game.all.select { |g| g.is_public? }
      {
        open: games.select { |g| g.is_open? }.sort_by { |g| [g.category, g.name] }.map { |g| g.summary_data },
        dev: games.select { |g| g.is_in_dev? }.sort_by { |g| [g.category, g.name] }.map { |g| g.summary_data },
        closed: games.select { |g| g.is_closed? }.sort_by { |g| g.name }.map { |g| g.summary_data }
      }
    end
  end
end
