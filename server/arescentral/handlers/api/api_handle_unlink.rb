module AresCentral
  class ApiHandleUnlinkCmd
    def initialize(params)
      @handle_id = params["handle_id"]
      @game_id = params["game_id"]
      @api_key = params["api_key"]
      @char_name = params["char_name"]
      @char_id = params["char_id"]
    end
  
    def self.required_fields
      [ "handle_id", "game_id", "api_key", "char_name", "char_id"]
    end
    
    def handle
     ApiHandleUnlinkCmd.required_fields.each do |field|
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
        
      linked_char = handle.linked_chars.select { |c| c.game == game && c.char_id == @char_id }.first

      if (!linked_char)
        return { status: "failure", error: "Character not linked to that handle." }.to_json
      end
        
      linked_char.update(retired: true)
    
      { status: "success", data: {} }.to_json
    end
  end
end