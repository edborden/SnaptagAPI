Fabricator(:user) do
	name { Faker::Name.first_name }
	email { |attrs| "#{attrs[:name].parameterize}@example.com" }
	zone_id 1000
	facebookid {Faker::Lorem.characters(10)}
	smallpic "https://scontent.xx.fbcdn.net/hprofile-xpa1/v/t1.0-1/p100x100/1453322_10152034746179906_322109215_n.jpg?oh=d5702d7c27f1415af068381c66e793f2&oe=5767AAE4"
	largepic "https://scontent.xx.fbcdn.net/hprofile-xpa1/v/t1.0-1/p200x200/1453322_10152034746179906_322109215_n.jpg?oh=a5579553c8576276c054b74d508e8c5c&oe=574C7B05"
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
	lat {(rand*0.05 -0.025) + 40.7127}
	lng {(rand*0.05 -0.025) - 74.0059}
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