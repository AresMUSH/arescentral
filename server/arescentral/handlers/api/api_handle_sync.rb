module AresCentral
  class ApiHandleSyncCmd
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
     ApiHandleSyncCmd.required_fields.each do |field|
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
    
      linked_char = handle.linked_chars.select { |c| c.game == game && "#{c.char_id}" == "#{@char_id}" && !c.retired }.first

      if (!linked_char)
        return { status: "success", data: { linked: false } }.to_json
      end
    
      linked_char.update(name: @char_name)
    
      data = {
        linked: true,
        autospace: handle.autospace, 
        page_autospace: handle.page_autospace,
        page_color: handle.page_color,
        timezone: handle.timezone,
        quote_color: handle.quote_color,
        friends: handle.friends.map { |f| f.name },
        ascii_only: handle.ascii_only,
        screen_reader: handle.screen_reader,
        profile: handle.profile
      }
    
      { status: "success", data: data }.to_json
    end
  end
end