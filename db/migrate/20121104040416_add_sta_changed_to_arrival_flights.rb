class AddStaChangedToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :sta_changed, :boolean, :default => false
  end
end
