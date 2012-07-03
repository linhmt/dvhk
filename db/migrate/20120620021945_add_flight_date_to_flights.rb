class AddFlightDateToFlights < ActiveRecord::Migration
  def change
    add_column :flights, :flight_date, :date
    add_column :flights, :is_domestic, :boolean
  end
end
