class CreateUserRoleMappings < ActiveRecord::Migration
  def up
    create_table :user_role_mappings, :force => true do |t|
      t.column :user_role_id, :integer
      t.column :user_id, :integer
      t.column :created_by, :integer
      t.column :updated_by, :integer
      t.column :is_active, :string
    end
  end

  def down
  end
end
