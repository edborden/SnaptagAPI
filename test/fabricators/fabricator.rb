Fabricator(:user) do
	firstname { Faker::Name.first_name }
	lastname { Faker::Name.last_name }
  	email { |attrs| "#{Faker::Lorem.characters(10)}@example.com" }
  	active true
  	token { |attrs| "#{Faker::Lorem.characters(30)}" }
  	facebookid { |attrs| "#{Faker::Number.number(30)}" }
end

Fabricator(:location) do
	latitude 40.12345
	longitude 41.24512
	accuracy 40
	timestamp 1236
end

Fabricator(:webbed_user, from: :user) do
	givers_count 6
	receivers_count 6
end