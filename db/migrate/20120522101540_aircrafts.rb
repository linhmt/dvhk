class Aircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.string :aircraft_type
      t.string :reg_no
      t.boolean :is_active
      t.timestamps
    end
    add_index(:aircrafts, :reg_no, {:unique => true})
  end
end
