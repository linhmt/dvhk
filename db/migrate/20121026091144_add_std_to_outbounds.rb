class AddStdToOutbounds < ActiveRecord::Migration
  def change
    add_column :outbounds, :std, :string, :limit => 5
  end
end
