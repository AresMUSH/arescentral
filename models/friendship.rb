class Friendship
  include Mongoid::Document
  belongs_to :owner, :class_name => "Handle", :inverse_of => :friendships
  belongs_to :friend, :class_name => "Handle", :inverse_of => :friends_of
end