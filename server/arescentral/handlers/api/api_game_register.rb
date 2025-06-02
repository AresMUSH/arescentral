module AresCentral
  class ApiGameRegisterCmd
    def initialize(params)
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
      [ "name", "host", "port", "category", "status" ]  
    end
    
    def handle
     ApiGameRegisterCmd.required_fields.each do |field|
       value = instance_variable_get("@#{field}")
       if value.blank?
          return { status: "failure", error: "Missing required field #{field}." }.to_json
        end
      end 
        
      if (!Game.categories.include?(@category))
        return { status: "failure", error: "Invalid game category." }.to_json
      end
      
      if (!Game.statuses.include?(@status))
        return { status: "failure", error: "Invalid game status." }.to_json
      end      
        
      # A game with the same name, port, and host is surely 
      # the same game, so don't double-create it. It was probably
      # just reinstalled.
      game = Game.all.select { |game| game.name == @name && game.host == @host && game.port == @port }.first
      if (game)
        return { status: "success", data: { game_id: game.id.to_s, api_key: game.api_key } }.to_json
      end
      
      game = Game.create(
        name: @name,
        description: @description,
        host: @host,
        port: @port,
        category: @category,
        website: @website,
        public_game: @public_game,
        status: @status,
        activity: @activity,
        last_ping: Time.now
      )
      
      { status: "success", data: { game_id: game.id.to_s, api_key: game.api_key } }.to_json
    end
  end
end

