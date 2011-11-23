# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111122054336) do

  create_table "passengers", :force => true do |t|
    t.string   "pax_name"
    t.string   "personal_id"
    t.integer  "routing_id"
    t.text     "remark"
    t.string   "ticket_class"
    t.integer  "priority_id"
    t.integer  "sequence"
    t.string   "origin_flt"
    t.string   "accepted_flt"
    t.boolean  "accepted"
    t.boolean  "called"
    t.boolean  "is_active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routings", :force => true do |t|
    t.string   "routing"
    t.string   "destination"
    t.boolean  "is_domestic"
    t.boolean  "include_transit"
    t.string   "transit_point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
