Fabricator(:user) do
	name { Faker::Name.first_name }
	email { |attrs| "#{attrs[:name].parameterize}@example.com" }
	zone_id 1000
	facebookid "738149905"
	activated_at {Time.now}
	targets_found_count {Faker::Number.number(2)}
	found_count {Faker::Number.number(2)}
	stalkers_exposed_count {Faker::Number.number(2)}
	exposed_count {Faker::Number.number(2)}
	after_create { |attrs| User.find(attrs[:id]).create_session token: Faker::Lorem.characters(10)}
end

Fabricator(:location) do
	lat {Faker::Address.latitude}
	lng {Faker::Address.longitude}
end

Fabricator(:location_in_nyc, from: :location) do
	lat {rand(40.7127..40.7128)}
	lng {rand(74.0058..74.0059) * -1 }
end

Fabricator(:location_in_boonton, from: :location) do
	lat 40.895929
	lng -74.409714
end

Fabricator(:location_in_london, from: :location) do
	lat 51.522503
	lng -0.128
end

Fabricator(:user_in_nyc, from: :user) do
	after_create { |attrs| Fabricate(:location_in_nyc, user_id: attrs[:id] )}
end

Fabricator(:user_in_boonton, from: :user) do
	after_create { |attrs| Fabricate(:location_in_boonton, user_id: attrs[:id] )}
end

Fabricator(:user_in_london, from: :user) do
	after_create { |attrs| Fabricate(:location_in_london, user_id: attrs[:id] )}
end

Fabricator(:webbed_user, from: :user) do
	givers_count 6
	receivers_count 6
end

Fabricator(:user_with_location, from: :user) do
	after_create { |attrs| Fabricate(:location, user_id: attrs[:id] )}
end

Fabricator(:active_test_user, from: :user_with_location) do
	stalkers_count 3
	targets_count 3
	givers_count 5
	receivers_count 6
end

Fabricator(:active_demo_user, from: :user) do
	stalkers_count 3
	targets_count 3
	givers_count 5
	receivers_count 6
end