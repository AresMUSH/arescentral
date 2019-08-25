class PastChar
  include Mongoid::Document
  field :name, type: String
  
  belongs_to :handle
  belongs_to :game
  
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