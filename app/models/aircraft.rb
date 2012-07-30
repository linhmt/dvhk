class Aircraft < ActiveRecord::Base
  default_scope :order => "reg_no asc"
end
