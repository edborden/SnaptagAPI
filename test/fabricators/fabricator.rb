Fabricator(:user) do
	name { Faker::Name.first_name }
	email { |attrs| "#{attrs[:name].parameterize}@example.com" }
	zone_id 1000
	facebookid {Faker::Lorem.characters(10)}
	smallpic "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/1456084_10152063553349906_822635544_n.jpg?oh=ceb7224e31d628f8d23236282b35068f&oe=54E4FB40&__gda__=1424790935_5167499d3af2d481c76c7d02afc043a7"
	mediumpic "https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/p130x130/1456084_10152063553349906_822635544_n.jpg?oh=fbde6daeb0e704e70d8ff0497b647a82&oe=54E5D9A8&__gda__=1428123508_af5d69f1f151b27762c7fcd74f3fb0e6"
	largepic "https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/1456084_10152063553349906_822635544_n.jpg?oh=c5debda4db66896833ba6d0c51cf07d1&oe=551C8CCB&__gda__=1423363987_27f27aec12e4c0b370aae26054d54241"
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