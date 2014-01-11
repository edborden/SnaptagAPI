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

ActiveRecord::Schema.define(version: 20131219191935) do

  create_table "activationqueues", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count",          default: 0,  null: false
  end

  create_table "hunts", force: true do |t|
    t.integer "hunter_id"
    t.integer "target_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "name"
    t.string   "handle"
    t.string   "provider"
    t.string   "uid"
    t.integer  "activationqueue_id"
    t.integer  "hunters_count",          default: 0,  null: false
    t.integer  "targets_count",          default: 0,  null: false
    t.boolean  "active",                 default: false,  null: false
  end

  add_index "users", ["activationqueue_id"], name: "index_users_on_activationqueue_id"

end
