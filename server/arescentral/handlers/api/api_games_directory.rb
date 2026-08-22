module AresCentral
  class ApiGamesDirectoryCmd
    def initialize(auth, params)
      @api_key = auth ? auth.auth_token : ""
      @client_id = auth ? auth.id : ""
    end
    
    def handle
       
      expected_key = Secrets.app_api_keys[@client_id]      
      
      if (!expected_key || @api_key != expected_key)
        raise AuthenticationError.new
      end
      
      games = Game.all.select { |g| g.is_public? && g.is_open? }.sort_by { |g| [g.category, g.name] }.map { |g| directory_summary(g) }
      
      games.to_json
    end
    
    def directory_summary(game)
      {
        name: game.name,
        description: game.description,
        hostname: game.host,
        port: game.port,
        genre: game.category,
        website: game.address,
        last_ping: game.last_ping ? game.last_ping.strftime('%m/%d/%Y') : "",
        status: game.status
      }
    end
  end
end

