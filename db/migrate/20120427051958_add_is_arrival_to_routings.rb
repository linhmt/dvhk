class AddIsArrivalToRoutings < ActiveRecord::Migration
  def change
    add_column :routings, :is_arrival, :boolean
  end
end
