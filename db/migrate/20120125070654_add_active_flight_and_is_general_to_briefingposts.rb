class AddActiveFlightAndIsGeneralToBriefingposts < ActiveRecord::Migration
  def change
    add_column :briefingposts, :active_flight, :string
    add_column :briefingposts, :is_general, :boolean
  end
end
