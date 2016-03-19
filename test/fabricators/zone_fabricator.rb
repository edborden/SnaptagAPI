Fabricator(:zone) do
	lat {Faker::Address.latitude}
	lng {Faker::Address.longitude}
end

Fabricator(:zone_in_nyc, from: :zone) do
	lat 40.71275
	lng -74.00585
end

Fabricator(:zone_in_boonton, from: :zone) do
	lat 40.920059
	lng -74.408684
end

Fabricator(:zone_in_london, from: :zone) do
	lat 51.522903
	lng -0.1275
end