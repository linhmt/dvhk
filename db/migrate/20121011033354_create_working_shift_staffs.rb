class CreateWorkingShiftStaffs < ActiveRecord::Migration
  def change
    create_table :working_shift_staffs do |t|
      t.text :roster
      t.date :duty_date
      t.timestamps
    end
    
    add_index(:working_shift_staffs, :duty_date, :unique => true)
  end
end
