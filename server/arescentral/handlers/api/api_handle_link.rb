module AresCentral
  class ApiHandleLinkCmd
    def initialize(params)
      @game_id = params["game_id"]
      @link_code = params["link_code"]
      @api_key = params["api_key"]
      @handle_name = params["handle_name"]
      @char_name = params["char_name"]
      @char_id = params["char_id"]
    end
    
    def self.required_fields
      [ "game_id", "link_code", "api_key", "handle_name", "char_name", "char_id"]
    end
    
    def handle
     ApiHandleLinkCmd.required_fields.each do |field|
       value = instance_variable_get("@#{field}")
       if value.blank?
          return { status: "failure", error: "Missing required field #{field}." }.to_json
        end
      end 
    
      handle = Handle.find_by_name(@handle_name)
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
    
      if (!handle.link_codes.include?(@link_code))
        return { status: "failure", error: "Invalid link code." }.to_json
      end
    
      codes = handle.link_codes
      codes.delete @link_code
      handle.update(link_codes: codes)

      game.create_or_update_linked_char(@char_name, @char_id, handle)
    
      { status: "success", data: { handle_id: handle.id.to_s, handle_name: handle.name } }.to_json
    end
  end
end