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

ActiveRecord::Schema.define(version: 20150829043006) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "key_id"
    t.string   "v_code"
    t.integer  "player_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
  end

  add_index "api_keys", ["player_id"], name: "index_api_keys_on_player_id"

  create_table "doctrine_fits", force: :cascade do |t|
    t.integer  "doctrine_id"
    t.integer  "fitting_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "doctrine_fits", ["doctrine_id"], name: "index_doctrine_fits_on_doctrine_id"
  add_index "doctrine_fits", ["fitting_id"], name: "index_doctrine_fits_on_fitting_id"

  create_table "doctrines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fittings", force: :cascade do |t|
    t.string   "name"
    t.string   "ship_name"
    t.string   "dna"
    t.text     "eft"
    t.string   "requirement_dna"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "pilot_skills", force: :cascade do |t|
    t.integer  "pilot_id"
    t.integer  "skill_id"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pilot_skills", ["pilot_id"], name: "index_pilot_skills_on_pilot_id"

  create_table "pilots", force: :cascade do |t|
    t.string   "character_id"
    t.string   "name"
    t.integer  "api_key_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "prime",        default: false
    t.integer  "access_level", default: 0
  end

  add_index "pilots", ["api_key_id"], name: "index_pilots_on_api_key_id"

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
