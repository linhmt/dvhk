class CreateTableWorkingShifts < ActiveRecord::Migration
  def up
    create_table :working_shifts do |t|
      t.column :shift_short_desc, :string
      t.column :description, :string
      t.column :is_active, :boolean
      t.timestamp
    end
  end

  def down
    drop_table :working_shifts
  end
end
