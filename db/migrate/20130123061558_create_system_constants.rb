class CreateSystemConstants < ActiveRecord::Migration
  def change
    create_table :system_constants do |t|
      t.string :name
      t.string :value
      t.timestamps
    end
  end
end
