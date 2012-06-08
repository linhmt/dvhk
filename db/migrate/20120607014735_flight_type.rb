class FlightType < ActiveRecord::Migration
  def change
    create_table :flight_types do |t|
      t.string :flight_no_from, :null => false
      t.string :flight_no_to, :null => false
      t.boolean :is_codeshare
      t.string :operator
      t.boolean :is_domestic
      t.boolean :is_active
      t.timestamps
    end
    add_index(:flight_types, :flight_no_from)
  end
end
