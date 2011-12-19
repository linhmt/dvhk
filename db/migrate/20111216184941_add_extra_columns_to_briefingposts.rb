class AddExtraColumnsToBriefingposts < ActiveRecord::Migration
  def change
    add_column :briefingposts, :active_shift, :integer, :default => 0
    add_column :briefingposts, :is_domestic, :boolean, :default => true, :null_disallowed => true
    add_column :briefingposts, :is_departure, :boolean, :default => true, :null_disallowed => true
  end
end
