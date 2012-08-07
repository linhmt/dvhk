class AddLnfStaffToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :lnf_user_id, :integer
  end
end
