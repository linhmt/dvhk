class AddFlightDateToFlights < ActiveRecord::Migration
  def change
    add_column :flights, :flight_date, :date
    add_column :flights, :is_domestic, :boolean
    add_index(:flights, [:flight_date, :flight_no], :unique => true, :name => 'flight_no_date')
  end
end
