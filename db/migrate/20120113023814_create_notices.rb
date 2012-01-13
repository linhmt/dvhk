class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :content, :null => false
      t.integer :user_id
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
