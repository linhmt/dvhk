class ChangeIsDomesticToBriefingTypeInt < ActiveRecord::Migration
  def up
    change_column :briefingposts, :is_domestic, :integer, :limit => 2, :default => 2
    change_column :briefingposts, :context, :text, :limit => 1000
  end

  def down
    change_column :briefingposts, :is_domestic, :boolean
    change_column :briefingposts, :context, :text
  end
end
