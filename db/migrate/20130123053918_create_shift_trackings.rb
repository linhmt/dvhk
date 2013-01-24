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
    add_column :shift_trackings, :allowed_negative, :decimal, :precision => 4, :scale => 2
    add_column :shift_trackings, :annual_day_begin, :decimal, :precision => 4, :scale => 2
    add_column :shift_trackings, :ot_day_begin, :decimal, :precision => 4, :scale => 2
    add_column :shift_trackings, :annual_day_used, :decimal, :precision => 4, :scale => 2
    add_column :shift_trackings, :ot_day_used, :decimal, :precision => 4, :scale => 2
  end
end
