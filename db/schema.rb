ActiveRecord::Schema.define(version: 20140310174426) do

  create_table "activationqueues", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count",          default: 0,  null: false
  end

  create_table "hunts", force: true do |t|
    t.integer "hunter_id"
    t.integer "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                 default: true,  null: false
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "gender"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "handle"
    t.string   "token"
    t.integer "facebookid"
    t.integer  "activationqueue_id"
    t.integer  "hunters_count",          default: 0,  null: false
    t.integer  "targets_count",          default: 0,  null: false
    t.boolean  "active",                 default: false,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["activationqueue_id"], name: "index_users_on_activationqueue_id"
  add_index "users", ["facebookid"], name: "index_users_on_facebookid"

end
