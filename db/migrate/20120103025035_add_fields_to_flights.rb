class AddFieldsToFlights < ActiveRecord::Migration
  def change
    add_column :flights, :status, :string
    add_column :flights, :approved_by, :integer
    add_column :flights, :is_approved, :boolean
    add_column :flights, :is_locked, :boolean
  end
end
