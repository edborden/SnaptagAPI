Fabricator(:user) do
	name { Faker::Name.first_name }
	email { |attrs| "#{attrs[:name].parameterize}@example.com" }
	zone_id 1000
	facebookid {Faker::Lorem.characters(10)}
	smallpic "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/1453322_10152034746179906_322109215_n.jpg?oh=2be7f4662187072a8d064f6f1ca06aeb&oe=55BF0524&__gda__=1438669811_a50703ef62311de875222cde0bcab743"
	largepic "https://scontent.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/p720x720/1453322_10152034746179906_322109215_n.jpg?oh=027f4f80abd2daa60b72e1197efbb4a3&oe=56028AB0"
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