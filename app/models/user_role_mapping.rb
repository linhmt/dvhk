class UserRoleMapping < ActiveRecord::Base
  belongs_to :user_role
  belongs_to :user
end
