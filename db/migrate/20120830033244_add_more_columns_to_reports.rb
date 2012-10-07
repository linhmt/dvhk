class AddMoreColumnsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :is_active, :boolean
    add_column :reports, :report_date, :date
    add_index :reports, [:report_date, :working_shift_id], :unique => true
  end
end
