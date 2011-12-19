class AddActiveDateAndIsCompletedToBriefingposts < ActiveRecord::Migration
  def change
    add_column :briefingposts, :active_date, :datetime
    add_column :briefingposts, :is_completed, :boolean, :default => false
  end
end
