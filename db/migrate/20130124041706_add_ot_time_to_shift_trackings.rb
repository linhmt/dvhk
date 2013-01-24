class AddOtTimeToShiftTrackings < ActiveRecord::Migration
  def change
    add_column :shift_trackings, :ot_time, :decimal, :precision => 4, :scale => 2
  end
end
