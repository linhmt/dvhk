class AddUserId2ToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :user_id_2, :integer
  end
end
