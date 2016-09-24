class Friendship
  include Mongoid::Document
  belongs_to :owner, :class_name => "Handle", :inverse_of => :friendships
  belongs_to :friend, :class_name => "Handle", :inverse_of => nil
end