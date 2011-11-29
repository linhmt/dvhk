class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.string :description
      t.integer :pri_level
      t.string :pri_name

      t.timestamps
    end
  end
end
