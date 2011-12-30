class CreateAssetItems < ActiveRecord::Migration
  def change
    create_table :asset_items do |t|
      t.column :item_id, :string
      t.column :description, :text
      t.column :recommended_stock, :integer
      t.column :item_unit, :string
      t.column :in_use, :boolean
      t.column :in_use_area, :string
      t.column :in_use_segment, :string
      t.timestamps
    end
  end
end
