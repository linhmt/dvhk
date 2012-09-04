class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.column :content, :text
      t.column :working_shift_id, :integer
      t.timestamps
    end
  end
end
