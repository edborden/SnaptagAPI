class LocationSerializer < ApplicationSerializer
	attributes :lat, :lon, :created_at
	has_one :user
end
