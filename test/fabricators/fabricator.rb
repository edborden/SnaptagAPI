Fabricator(:user) do
	name { Faker::Name.name }
  	email { |attrs| "#{attrs[:name].parameterize}@example.com" }
  	password { Faker::Lorem.characters(10) }
end
