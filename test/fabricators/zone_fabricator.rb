Fabricator(:zone) do
	lat {Faker::Address.latitude}
	lon {Faker::Address.longitude}
	range 1200
end

Fabricator(:zone_in_nyc, from: :zone) do
	lat 40.7127
	lon -74.0059
	range 15000
end

Fabricator(:zone_in_boonton, from: :zone) do
	lat 40.920059
	lon -74.408684
end

Fabricator(:zone_in_london, from: :zone) do
	lat 51.522903
	lon -0.1275
end