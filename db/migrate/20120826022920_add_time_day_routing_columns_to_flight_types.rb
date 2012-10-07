class AddTimeDayRoutingColumnsToFlightTypes < ActiveRecord::Migration
  def change
    add_column :flight_types, :operating_day, :string, :default => '0123456'
    add_column :flight_types, :operating_time, :time
    add_column :flight_types, :is_arrival, :boolean, :default => true
    add_column :flight_types, :routing_id, :integer
  end
end
