class LinkedChar
  include Mongoid::Document
  field :name, type: String
  field :char_id, type: String
  
  belongs_to :handle
  belongs_to :game
  
  def display_name
    "#{name}@#{game.name}"
  end
end