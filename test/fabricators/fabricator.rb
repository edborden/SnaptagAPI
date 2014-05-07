Fabricator(:user) do
	firstname { Faker::Name.first_name }
	lastname { Faker::Name.last_name }
  	email { |attrs| "#{Faker::Lorem.characters(10)}@example.com" }
  	active true
  	token { |attrs| "#{Faker::Lorem.characters(10)}" }
  	facebookid { |attrs| "#{Faker::Number.number(4)}" }
  	smallpic "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/p50x50/75022_10
152135585049906_64496435_t.jpg" 
	mediumpic "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-prn1/t1.0-0/75022_101521355
85049906_64496435_s.jpg"
	largepic "https://scontent-a.xx.fbcdn.net/hphotos-prn1/t1.0-9/s720x720/75022_101521355
85049906_64496435_n.jpg"
end

Fabricator(:location) do
	latitude { |attrs| "#{Faker::Address.latitude}" }
	longitude { |attrs| "#{Faker::Address.longitude}" }
	accuracy 40
	timestamp 1236
end

Fabricator(:webbed_user, from: :user) do
	givers_count 6
	receivers_count 6
end

Fabricator(:web_test_user, from: :user) do
	activationqueue_id 0
end

