class LocationSerializer < ActiveModel::Serializer
	attributes :id,:lat, :lon, :created_at
end
