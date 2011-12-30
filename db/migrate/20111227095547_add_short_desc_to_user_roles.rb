class AddShortDescToUserRoles < ActiveRecord::Migration
  def change
    add_column :user_roles, :short_desc, :string
  end
end
