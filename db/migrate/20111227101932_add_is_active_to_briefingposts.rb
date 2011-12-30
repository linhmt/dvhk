class AddIsActiveToBriefingposts < ActiveRecord::Migration
  def change
    add_column :briefingposts, :is_active, :boolean
  end
end
