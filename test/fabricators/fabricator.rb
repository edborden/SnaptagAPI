Fabricator(:user) do
	name { Faker::Name.first_name }
	email "#{Faker::Lorem.characters(10)}@example.com" 
	zone_id 1000
	token {Faker::Lorem.characters(10)}
	facebookid {Faker::Lorem.characters(10)}
	smallpic "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg" 
	mediumpic "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg"
	largepic "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg"
	activated_at {Time.now}
	exposed_count {Faker::Number.number(2)}
	counteract_count {Faker::Number.number(2)}
	disavowed_count {Faker::Number.number(2)}
	compromised_count {Faker::Number.number(2)}
end

Fabricator(:location) do
	lat {Faker::Address.latitude}
	lon {Faker::Address.longitude}
	accuracy 40
	timestamp Time.now
end

Fabricator(:location_in_nyc, from: :location) do
	lat {(rand*0.05 -0.025) + 40.7127}
	lon {(rand*0.05 -0.025) - 74.0059}
end

Fabricator(:location_in_boonton, from: :location) do
	lat 40.895929
	lon -74.409714
end

Fabricator(:location_in_london, from: :location) do
	lat 51.522503
	lon -0.128
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
	hunters_count 3
	targets_count 3
	givers_count 5
	receivers_count 6
end

Fabricator(:active_demo_user, from: :user) do
	hunters_count 3
	targets_count 3
	givers_count 5
	receivers_count 6
end