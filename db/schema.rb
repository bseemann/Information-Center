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
    t.datetime "created_at",                       null: false
    t.string   "updated_at",                       null: false
    t.string   "local_commitment"
    t.boolean  "dir",              default: false
    t.boolean  "show",             default: true
    t.string   "path",             default: "/"
    t.boolean  "public",           default: false
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
    t.date     "xp_birthday_date"
    t.string   "xp_full_name"
    t.string   "xp_last_name"
    t.string   "xp_profile_photo_url"
    t.integer  "xp_home_lc_id"
    t.integer  "xp_home_mc_id"
    t.integer  "xp_status"
    t.boolean  "xp_interviewed",            default: false
    t.string   "xp_phone"
    t.string   "xp_location"
    t.datetime "xp_created_at"
    t.datetime "xp_updated_at"
    t.string   "xp_middles_names"
    t.string   "xp_introduction"
    t.string   "xp_aiesec_email"
    t.boolean  "xp_payment",                default: false
    t.integer  "xp_views"
    t.integer  "xp_favourites_count"
    t.datetime "xp_contacted_at"
    t.string   "xp_contacted_by"
    t.integer  "xp_gender"
    t.text     "xp_address_info"
    t.string   "xp_contact_info"
    t.integer  "xp_current_office_id"
    t.string   "xp_cv_info"
    t.string   "xp_profile_photos_urls"
    t.string   "xp_cover_photo_urls"
    t.string   "xp_profile"
    t.string   "xp_academic_experience"
    t.string   "xp_missing_profile_fields"
    t.integer  "xp_nps_score"
    t.string   "xp_permissions"
    t.integer  "entity_exchange_lc_id"
    t.integer  "interested_program"
    t.integer  "interested_sub_product"
    t.integer  "how_got_to_know_aiesec"
    t.text     "customized_fields"
    t.text     "control_podio"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.string   "local_commitment"
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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "local_commitment"
  end

end
