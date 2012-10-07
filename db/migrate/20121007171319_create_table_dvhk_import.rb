class CreateTableDvhkImport < ActiveRecord::Migration
  def up
    create_table :dvhk_import do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :short_name, :string
    end
    
  end

  def down
    drop_table :dvhk_import
  end
end
