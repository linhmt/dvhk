class AlterUserRoleMappingsTable < ActiveRecord::Migration
  def change
    change_table(:user_role_mappings) do |t|
      t.change :is_active, :boolean, :default => true
      t.timestamp
    end
  end
end
