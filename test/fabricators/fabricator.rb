Fabricator(:user) do
	name { Faker::Name.name }
  	email { |attrs| "#{Faker::Lorem.characters(10)}@example.com" }
  	password { Faker::Lorem.characters(10) }
end
