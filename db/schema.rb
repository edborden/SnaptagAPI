ActiveRecord::Schema.define(version: 20140310174426) do

	create_table "activationqueues", force: true do |t|
		t.datetime "created_at"
		t.datetime "updated_at"
		t.integer  "users_count",          default: 0,  null: false
		t.integer "zone_id"
	end

	create_table "hunts", force: true do |t|
		t.integer "stalker_id"
		t.integer "target_id"
		t.datetime "created_at"
		t.datetime "completed_at"
		t.integer "stealth_stolen"
		t.boolean  "was_exposed",         default: false,  null: false
		t.boolean  "active",               default: true,  null: false
		t.decimal "lat",  precision: 8, scale: 6
		t.decimal "lng", precision: 9, scale: 6
	end
	add_index "hunts", ["stalker_id"], name: "index_hunts_on_stalker_id"
	add_index "hunts", ["target_id"], name: "index_hunts_on_target_id"

	create_table "locations", force: true do |t|
		t.integer "user_id"
		t.decimal "lat",  precision: 8, scale: 6, null: false	
		t.decimal "lng", precision: 9, scale: 6, null: false	
		t.datetime "created_at"
	end
	add_index "locations", ["user_id"], name: "index_locations_on_user_id"

	create_table "sessions", force: true do |t|
		t.string   "token"
		t.integer "user_id"
	end
	add_index "sessions", ["token"], name: "index_sessions_on_token"

	create_table "users", force: true do |t|
		t.string   "email"
		t.string   "gender"
		t.string   "name"
		t.string  "facebookid"
		t.string   "smallpic"
		t.string   "mediumpic"
		t.string   "largepic"
		t.string   "birthday"
		t.integer  "activationqueue_id"
		t.integer  "zone_id"
		t.integer  "stealth",        default: 0,  null: false
		t.integer  "targets_found_count",        default: 0,  null: false
		t.integer  "found_count",          default: 0,  null: false
		t.integer  "stalkers_exposed_count",          default: 0,  null: false		
		t.integer  "exposed_count",          default: 0,  null: false
		t.integer  "stalkers_count",          default: 0,  null: false
		t.integer  "targets_count",          default: 0,  null: false
		t.integer  "givers_count",          default: 0,  null: false
		t.integer  "receivers_count",          default: 0,  null: false		
		t.datetime "created_at"
		t.datetime "updated_at"
		t.datetime "activated_at"
		t.datetime "seen_at"
	end
	add_index "users", ["activationqueue_id"], name: "index_users_on_activationqueue_id"
	add_index "users", ["facebookid"], name: "index_users_on_facebookid"
	add_index "users", ["zone_id"], name: "index_users_on_zone_id"

	create_table "webs", force: true do |t|
		t.integer  "giver_id"
		t.integer  "receiver_id"
	end
	add_index "webs", ["giver_id"], name: "index_webs_on_giver_id"
	add_index "webs", ["receiver_id"], name: "index_webs_on_receiver_id"

	create_table "zones", force: true do |t|
		t.decimal "lat",  precision: 8, scale: 6, null: false	
		t.decimal "lng", precision: 9, scale: 6, null: false
		t.integer "range", null:false, default: DEFAULT_MAX_DISTANCE
		t.integer "grow_id"
	end

end
