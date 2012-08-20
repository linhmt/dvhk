class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.column :active_date, :date
      t.timestamps
    end
  end
end
