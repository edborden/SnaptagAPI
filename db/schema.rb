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
		t.datetime "completed_at"
		t.boolean  "counteracted",               default: false,  null: false
		t.boolean  "active",               default: true,  null: false
	end

	add_index "hunts", ["hunter_id"], name: "index_users_on_hunter_id"
	add_index "hunts", ["target_id"], name: "index_users_on_target_id"

	create_table "users", force: true do |t|
		t.string   "email"
		t.string   "gender"
		t.string   "firstname"
		t.string   "lastname"
		t.string   "token"
		t.integer "facebookid"
		t.string   "smallpic"
		t.string   "mediumpic"
		t.string   "largepic"
		t.string   "birthday"
		t.integer  "activationqueue_id"
		t.integer  "exposed_count",        default: 0,  null: false
		t.integer  "counteract_count",          default: 0,  null: false
		t.integer  "disavowed_count",          default: 0,  null: false		
		t.integer  "compromised_count",          default: 0,  null: false
		t.integer  "hunters_count",          default: 0,  null: false
		t.integer  "targets_count",          default: 0,  null: false
		t.integer  "givers_count",          default: 0,  null: false
		t.integer  "receivers_count",          default: 0,  null: false		
		t.boolean  "active",                 default: false,  null: false
		t.datetime "created_at"
		t.datetime "updated_at"
	end

	add_index "users", ["activationqueue_id"], name: "index_users_on_activationqueue_id"
	add_index "users", ["facebookid"], name: "index_users_on_facebookid"
	add_index "users", ["token"], name: "index_users_on_token"

	create_table "webs", force: true do |t|
		t.integer  "giver_id"
		t.integer  "receiver_id"
	end

add_index "webs", ["giver_id"], name: "index_users_on_giver_id"
add_index "webs", ["receiver_id"], name: "index_users_on_receiver_id"

end
