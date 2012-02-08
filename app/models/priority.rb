class Priority < ActiveRecord::Base
  default_scope :order => "pri_level asc"
end
