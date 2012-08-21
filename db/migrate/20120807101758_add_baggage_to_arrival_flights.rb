class AddBaggageToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :baggage, :text
    add_column :arrival_flights, :notify_count, :integer
    add_column :arrival_flights, :notify_by, :integer
    add_column :arrival_flights, :is_active, :boolean
    add_index :arrival_flights, [:flight_no, :flight_date], :name => 'flight_index'
  end
end
