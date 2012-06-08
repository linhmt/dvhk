class CreateOutbounds < ActiveRecord::Migration
  def change
    create_table :outbounds do |t|
      t.integer :arrival_flight_id
      t.integer :flight_id
      t.string :flight_no
      t.integer :pax_number

      t.timestamps
    end
  end
end
