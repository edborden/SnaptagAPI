Fabricator(:user) do
	firstname { Faker::Name.first_name }
	lastname { Faker::Name.last_name }
  	email { |attrs| "#{Faker::Lorem.characters(10)}@example.com" }
  	active true
  	token { |attrs| "#{Faker::Lorem.characters(30)}" }
  	facebookid { |attrs| "#{Faker::Number.number(30)}" }
end

Fabricator(:webbed_user, from: :user) do
	givers_count 6
	receivers_count 6
end