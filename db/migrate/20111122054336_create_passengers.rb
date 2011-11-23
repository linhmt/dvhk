class CreatePassengers < ActiveRecord::Migration
  def change
    create_table :passengers do |t|
      t.string :pax_name
      t.string :personal_id
      t.integer :routing_id
      t.text :remark
      t.string :ticket_class
      t.integer :priority_id
      t.integer :sequence
      t.string :origin_flt
      t.string :accepted_flt
      t.boolean :accepted
      t.boolean :called
      t.boolean :is_active
      t.integer :user_id

      t.timestamps
    end
  end
end
