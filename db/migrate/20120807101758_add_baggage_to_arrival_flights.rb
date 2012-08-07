class AddBaggageToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :ssr, :text
  end
end
