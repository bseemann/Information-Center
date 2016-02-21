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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160221043713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.integer  "expa_id"
    t.string   "expa_url"
    t.string   "expa_status"
    t.integer  "expa_current_status"
    t.datetime "expa_created_at"
    t.datetime "expa_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "archives", force: :cascade do |t|
    t.string   "name"
    t.string   "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offices", force: :cascade do |t|
    t.integer  "expa_id"
    t.string   "expa_name"
    t.string   "expa_full_name"
    t.string   "expa_url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  create_table "people", force: :cascade do |t|
    t.integer  "expa_id"
    t.string   "expa_email"
    t.string   "expa_url"
    t.string   "expa_full_name"
    t.string   "expa_last_name"
    t.string   "expa_profile_photo_url"
    t.integer  "expa_home_lc"
    t.integer  "expa_home_mc"
    t.integer  "expa_status"
    t.string   "expa_phone"
    t.datetime "expa_created_at"
    t.datetime "expa_updated_at"
    t.string   "expa_middles_names"
    t.string   "expa_aiesec_email"
    t.datetime "expa_contacted_at"
    t.integer  "expa_contacted_by"
    t.integer  "expa_gender"
    t.text     "expa_address_info"
    t.string   "expa_contact_info"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rd_station_controls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "photo_url"
    t.string   "postion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
