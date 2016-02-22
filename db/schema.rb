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

ActiveRecord::Schema.define(version: 20160222043414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archives", force: :cascade do |t|
    t.string   "name"
    t.string   "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expa_applications", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_url"
    t.integer  "xp_status"
    t.integer  "xp_current_status"
    t.datetime "xp_created_at"
    t.datetime "xp_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "expa_offices", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_name"
    t.string   "xp_full_name"
    t.string   "xp_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "expa_people", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_email"
    t.string   "xp_url"
    t.string   "xp_full_name"
    t.string   "xp_last_name"
    t.string   "xp_profile_photo_url"
    t.integer  "xp_home_lc"
    t.integer  "xp_home_mc"
    t.integer  "xp_status"
    t.string   "xp_phone"
    t.datetime "xp_created_at"
    t.datetime "xp_updated_at"
    t.string   "xp_middles_names"
    t.string   "xp_aiesec_email"
    t.datetime "xp_contacted_at"
    t.integer  "xp_contacted_by"
    t.integer  "xp_gender"
    t.text     "xp_address_info"
    t.string   "xp_contact_info"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  create_table "rd_controls", force: :cascade do |t|
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
