class CreateArrivalFlights < ActiveRecord::Migration
  def change
    create_table :arrival_flights do |t|
      t.string :reg_no
      t.string :flight_no
      t.integer :routing_id
      t.integer :user_id
      t.date  :flight_date
      t.time  :sta
      t.time  :eta
      t.time  :ata
      t.timestamps
    end
  end
end
