class ChangeIsDomesticToBriefingTypeInt < ActiveRecord::Migration
  def up
    change_column :briefingposts, :is_domestic, :integer, :limit => 2, :default => 2
  end

  def down
    change_column :briefingposts, :is_domestic, :boolean
  end
end
