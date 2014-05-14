Fabricator(:user) do
	firstname { Faker::Name.first_name }
	lastname { Faker::Name.last_name }
  	email "#{Faker::Lorem.characters(10)}@example.com" 
  	active true
  	token {Faker::Lorem.characters(10)}
  	facebookid {Faker::Lorem.characters(10)}
  	smallpic "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg" 
	mediumpic "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg"
	largepic "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg"
end

Fabricator(:location) do
	latitude {Faker::Address.latitude}
	longitude {Faker::Address.longitude}
	accuracy 40
	timestamp 1236
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