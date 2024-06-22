module AresCentral
  class LinkedChar < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :char_id
    attribute :temp_password
    attribute :retired, :type => DataType::Boolean, :default => false
    
    reference :handle, "AresCentral::Handle"
    reference :game, "AresCentral::Game"
  
    def display_name
      "#{name}@#{game.name}"
    end
  
    def public_char?
      self.game.public_game
    end
  
    def visible_to?(handle)
      return true if self.public_char?
      return false if !handle
      return true if handle.is_admin
      return true if handle == self.handle
      return handle.has_char_on_game?(self.game)
    end
    
  end
  
end