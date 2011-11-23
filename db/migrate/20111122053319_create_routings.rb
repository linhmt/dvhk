class CreateRoutings < ActiveRecord::Migration
  def change
    create_table :routings do |t|
      t.string :routing
      t.string :destination
      t.boolean :is_domestic
      t.boolean :include_transit
      t.string :transit_point

      t.timestamps
    end
  end
end
