class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.active_date :datetime
      t.timestamps
    end
  end
end
