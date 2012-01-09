class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.column :flight_no, :string
      t.column :routing_id, :integer
      t.column :user_id, :integer
      t.column :aircraft_id, :integer
      t.column :config, :string
      t.column :booking, :string
      t.column :on_board, :string
      t.column :std, :datetime
      t.column :atd, :datetime
      t.column :closing_time, :datetime
      t.column :meals, :string
      t.column :priority_pax, :text
      t.column :special_request_pax, :text
      t.column :remark, :text
      t.column :booked_transit_pax, :string
      t.column :transit_pax, :string
      t.column :outbound_pax, :string
      t.column :inbound_pax, :string
      t.timestamps
    end
  end
end
