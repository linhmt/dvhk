class AddDetailsToOutbounds < ActiveRecord::Migration
  def change
    add_column :outbounds, :details, :text
  end
end
