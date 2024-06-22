module AresCentral
  class ApiGameUpdateCmd
    def initialize(params)
      @game_id = params["game_id"]
      @api_key = params["api_key"]
      @name = params["name"]
      @host = params["host"]
      @port = params["port"]
      @category = params["category"]
      @status = params["status"]
      @description = params["description"]
      @public_game = "#{params['public_game']}".to_bool
      @website = params["website"]
      @activity = params["activity"].blank? ? {} : JSON.parse(params["activity"])
    end

    def self.required_fields
      # activity, website, desc optional
      [ "game_id", "api_key", "name", "host", "port", "category", "status" ]  
    end
    
    def handle
     ApiGameUpdateCmd.required_fields.each do |field|
       value = instance_variable_get("@#{field}")
       if value.blank?
          return { status: "failure", error: "Missing required field #{field}." }.to_json
        end
      end 

      game = Game.find_by_old_or_new_id(@game_id)
      if (!game)
        return { status: "failure", error: "Game not found." }.to_json
      end
    
      if (game.api_key != @api_key)
        return { status: "failure", error: "Invalid API key." }.to_json
      end

      if (!Game.categories.include?(@category))
        return { status: "failure", error: "Invalid game category." }.to_json
      end
      
      if (!Game.statuses.include?(@status))
        return { status: "failure", error: "Invalid game status." }.to_json
      end      
      
      if (@status != game.status)
        last_status_update = Time.now
      else
        last_status_update = game.last_status_update
      end
      
      game = game.update(
        name: @name,
        description: @description,
        host: @host,
        port: @port,
        category: @category,
        website: @website,
        public_game: @public_game,
        status: @status,
        activity: @activity,
        last_ping: Time.now,
        last_status_update: last_status_update
      )
    
      { status: "success" }.to_json
    end
  end
end

