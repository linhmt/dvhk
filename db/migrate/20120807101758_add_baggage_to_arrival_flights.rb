class AddBaggageToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :baggage, :text
  end
end
