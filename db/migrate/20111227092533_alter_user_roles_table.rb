class AlterUserRolesTable < ActiveRecord::Migration
  def change
    change_table :user_roles do |t|
      t.change :is_active, :boolean, :default => true
      t.remove :user_role_id
      t.timestamps
    end
  end
end
