class LocationSerializer < ApplicationSerializer
	attributes :lat, :lng, :created_at
	has_one :user
end
