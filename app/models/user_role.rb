class UserRole < ActiveRecord::Base
  has_many :user_role_mappings, :dependent => :destroy
  has_many :users, :through => :user_role_mappings
end
