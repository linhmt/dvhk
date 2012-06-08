class AddSsrToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :ssr, :text
    add_column :arrival_flights, :remarks, :text
    add_column :arrival_flights, :is_domestic, :boolean
    add_column :arrival_flights, :is_approval, :boolean
    add_column :arrival_flights, :approval_by, :integer
  end
end
