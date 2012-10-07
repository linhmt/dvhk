class ChangeIsDomesticToBriefingTypeInt < ActiveRecord::Migration
  def up
    change_column :briefingposts, :is_domestic, :integer, :limit => 2, :default => 2
    remove_column(:briefingposts, :is_general)
    change_column :briefingposts, :content, :text, :limit => 1000
  end

  def down
    change_column :briefingposts, :is_domestic, :boolean
    add_column(:briefingposts, :is_general, :boolean)
    change_column :briefingposts, :content, :text
  end
end
