class AddApprovedByToReports < ActiveRecord::Migration
  def change
    add_column :reports, :approved_by, :integer
  end
end
