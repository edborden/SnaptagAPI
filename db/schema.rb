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

ActiveRecord::Schema.define(version: 20160319163657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activationqueues", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count", default: 0, null: false
    t.integer  "zone_id"
  end

  create_table "alerters", force: true do |t|
    t.integer "user_id"
    t.string  "reg_id"
    t.string  "platform"
  end

  add_index "alerters", ["user_id"], name: "index_alerters_on_user_id", using: :btree

  create_table "hunts", force: true do |t|
    t.integer  "stalker_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "completed_at"
    t.integer  "stealth_stolen"
    t.string   "image_id"
    t.boolean  "was_exposed",                            default: false, null: false
    t.boolean  "active",                                 default: true,  null: false
    t.decimal  "lat",            precision: 8, scale: 6
    t.decimal  "lng",            precision: 9, scale: 6
  end

  add_index "hunts", ["stalker_id", "target_id"], name: "index_hunts_on_stalker_id_and_target_id", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "user_id"
    t.decimal  "lat",        precision: 8, scale: 6, null: false
    t.decimal  "lng",        precision: 9, scale: 6, null: false
    t.datetime "created_at"
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_type", using: :btree

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id", "type"], name: "index_mailboxer_notifications_on_conversation_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id"], name: "index_mailboxer_notifications_on_notified_object_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "sessions", force: true do |t|
    t.string  "token"
    t.integer "user_id"
  end

  add_index "sessions", ["token"], name: "index_sessions_on_token", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "gender"
    t.string   "name"
    t.string   "facebookid"
    t.string   "smallpic"
    t.string   "largepic"
    t.string   "birthday"
    t.integer  "activationqueue_id"
    t.integer  "zone_id"
    t.integer  "stealth",                default: 0, null: false
    t.integer  "targets_found_count",    default: 0, null: false
    t.integer  "found_count",            default: 0, null: false
    t.integer  "stalkers_exposed_count", default: 0, null: false
    t.integer  "exposed_count",          default: 0, null: false
    t.integer  "stalkers_count",         default: 0, null: false
    t.integer  "targets_count",          default: 0, null: false
    t.integer  "givers_count",           default: 0, null: false
    t.integer  "receivers_count",        default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
    t.datetime "seen_at"
  end

  add_index "users", ["activationqueue_id", "facebookid", "zone_id"], name: "index_users_on_activationqueue_id_and_facebookid_and_zone_id", using: :btree

  create_table "versions", force: true do |t|
    t.integer "user_id"
    t.string  "revision"
    t.string  "platform"
  end

  create_table "webs", force: true do |t|
    t.integer "giver_id"
    t.integer "receiver_id"
  end

  add_index "webs", ["giver_id", "receiver_id"], name: "index_webs_on_giver_id_and_receiver_id", using: :btree

  create_table "zones", force: true do |t|
    t.decimal "lat",     precision: 8, scale: 6,                null: false
    t.decimal "lng",     precision: 9, scale: 6,                null: false
    t.integer "range",                           default: 2500, null: false
    t.integer "grow_id"
  end

  Foreigner.load
end
