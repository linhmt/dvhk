class CreateTableUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_roles, :force => true do |t|
      t.column :user_role_id, :integer
      t.column :description, :string
      t.column :created_by, :integer
      t.column :updated_by, :integer
      t.column :is_active, :string
    end
  end

  def self.down
    drop_table :user_roles
  end
end
