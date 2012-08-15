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

ActiveRecord::Schema.define(:version => 20120807101758) do

  create_table "arrival_flights", :force => true do |t|
    t.string   "flight_no"
    t.integer  "user_id"
    t.datetime "flight_date"
    t.datetime "sta"
    t.datetime "eta"
    t.datetime "ata"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ssr"
    t.text     "remarks"
    t.boolean  "is_domestic"
    t.boolean  "is_approval"
    t.integer  "approval_by"
    t.integer  "lnf_user_id"
    t.text     "baggage"
  end

  create_table "asset_items", :force => true do |t|
    t.string   "item_id"
    t.text     "description"
    t.integer  "recommended_stock"
    t.string   "item_unit"
    t.boolean  "in_use"
    t.string   "in_use_area"
    t.string   "in_use_segment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "briefingposts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_shift",  :default => 0
    t.boolean  "is_domestic",   :default => true
    t.boolean  "is_departure",  :default => true
    t.datetime "active_date"
    t.boolean  "is_completed",  :default => false
    t.boolean  "is_active"
    t.string   "active_flight"
    t.boolean  "is_general"
  end

  add_index "briefingposts", ["user_id", "created_at"], :name => "index_briefingposts_on_user_id_and_created_at"

  create_table "data_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dailyroster_file_name"
    t.string   "dailyroster_content_type"
    t.integer  "dailyroster_file_size"
    t.datetime "dailyroster_updated_at"
    t.boolean  "is_arrival"
  end

  create_table "flight_types", :force => true do |t|
    t.string   "flight_no_from", :null => false
    t.string   "flight_no_to",   :null => false
    t.boolean  "is_codeshare"
    t.string   "operator"
    t.boolean  "is_domestic"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flight_types", ["flight_no_from"], :name => "index_flight_types_on_flight_no_from"

  create_table "flights", :force => true do |t|
    t.string   "flight_no"
    t.integer  "routing_id"
    t.integer  "user_id"
    t.integer  "aircraft_id"
    t.string   "config"
    t.string   "booking"
    t.string   "on_board"
    t.datetime "std"
    t.datetime "atd"
    t.datetime "closing_time"
    t.string   "meals"
    t.text     "priority_pax"
    t.text     "special_request_pax"
    t.text     "remark"
    t.string   "booked_transit_pax"
    t.string   "transit_pax"
    t.string   "outbound_pax"
    t.string   "inbound_pax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "approved_by"
    t.boolean  "is_approved"
    t.boolean  "is_locked"
    t.date     "flight_date"
    t.boolean  "is_domestic"
  end

  add_index "flights", ["flight_date", "flight_no"], :name => "flight_no_date", :unique => true

  create_table "notices", :force => true do |t|
    t.text     "content",                      :null => false
    t.integer  "user_id"
    t.boolean  "is_active",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outbounds", :force => true do |t|
    t.integer  "arrival_flight_id"
    t.integer  "flight_id"
    t.string   "flight_no"
    t.integer  "pax_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "priorities", :force => true do |t|
    t.string   "description"
    t.integer  "pri_level"
    t.string   "pri_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active"
    t.datetime "expired_date"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "routings", :force => true do |t|
    t.string   "routing"
    t.string   "destination"
    t.boolean  "is_domestic"
    t.boolean  "include_transit"
    t.string   "transit_point"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_arrival"
  end

  create_table "user_role_mappings", :force => true do |t|
    t.integer "user_role_id"
    t.integer "user_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_active",    :default => true
  end

  create_table "user_roles", :force => true do |t|
    t.string   "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_active",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_desc"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "short_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
