class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|

      t.timestamps
    end
  end
end
