class AddIsActiveAndExpiredDateToPriorities < ActiveRecord::Migration
  def change
    add_column :priorities, :is_active, :boolean
    add_column :priorities, :expired_date, :datetime
  end
end
