class CreateShiftTrackings < ActiveRecord::Migration
  def change
    create_table :shift_trackings do |t|
      t.integer :staff_id
      t.text :working_duties
      t.integer :weekend
      t.integer :holiday
      t.decimal :invalid_hour, :precision => 4, :scale => 2
      t.timestamps
    end
  end
end
