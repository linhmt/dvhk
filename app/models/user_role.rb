class UserRole < ActiveRecord::Base
  has_many :user_role_mapping, :dependent => :destroy
  has_many :users, :through => :user_role_mappings
end
