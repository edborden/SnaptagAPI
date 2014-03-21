Fabricator(:user) do
	firstname { Faker::Name.first_name }
	lastname { Faker::Name.last_name }
  	email { |attrs| "#{Faker::Lorem.characters(10)}@example.com" }
  	active true
  	token "#{Faker::Lorem.characters(30)}"
end