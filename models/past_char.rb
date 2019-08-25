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
end