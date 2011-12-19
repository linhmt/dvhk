class CreateBriefingposts < ActiveRecord::Migration
  def change
    create_table :briefingposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index(:briefingposts, [:user_id, :created_at])
  end
end
