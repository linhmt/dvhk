class AddOtTimeToShiftTrackings < ActiveRecord::Migration
  def change
    add_column :shift_trackings, :standard_day_off, :integer
    add_column :shift_trackings, :month_year, :string, :limit => 6
    
    add_column :shift_trackings, :ot_time, :decimal, :precision => 6, :scale => 3    
    add_column :shift_trackings, :annual_day_used, :decimal, :precision => 6, :scale => 3
    add_column :shift_trackings, :ot_day_used, :decimal, :precision => 6, :scale => 3
    
    add_column :shift_trackings, :allowed_negative, :decimal, :precision => 6, :scale => 3
    add_column :shift_trackings, :annual_day_begin, :decimal, :precision => 6, :scale => 3
    add_column :shift_trackings, :ot_day_begin, :decimal, :precision => 6, :scale => 3
    
    add_column :shift_trackings, :ot_offhour, :decimal, :precision => 6, :scale => 3
    add_column :shift_trackings, :ot_workhour, :decimal, :precision => 6, :scale => 3
    add_column :shift_trackings, :ot_nighhour, :decimal, :precision => 6, :scale => 3
    
    add_column :shift_trackings, :fullname, :string
  end
end
