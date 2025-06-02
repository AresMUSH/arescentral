module AresCentral
  class ApiResetCharPasswordCmd
    def initialize(params)
      @handle_id = params["handle_id"]
      @game_id = params["game_id"]
      @api_key = params["api_key"]
      @char_id = params["char_id"]
      @password = params["password"]
    end
      
    def self.required_fields
      [ "handle_id", "game_id", "api_key", "char_id", "password"]
    end
    
    def handle
     ApiResetCharPasswordCmd.required_fields.each do |field|
       value = instance_variable_get("@#{field}")
       if value.blank?
          return { status: "failure", error: "Missing required field #{field}." }.to_json
        end
      end 
    
      handle = Handle.find_by_old_or_new_id(@handle_id)
      if (!handle)
        return { status: "failure", error: "Handle not found." }.to_json
      end
    
      game = Game.find_by_old_or_new_id(@game_id)
      if (!game)
        return { status: "failure", error: "Game not found." }.to_json
      end
    
      if (game.api_key != @api_key)
        return { status: "failure", error: "Invalid API key." }.to_json
      end
    
      link = handle.linked_chars.select { |c| c.game == game && c.char_id == @char_id }.first    
      if (!link)
        return { status: "failure", error: "That character is not linked to your handle." }.to_json
      end
    
      matched = link.temp_password == @password
      if (matched)
        link.update(temp_password: nil)
      end
    
      { status: "success", data: { matched: matched } }.to_json
    end
  end
end