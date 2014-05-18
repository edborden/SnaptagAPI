class LocationSerializer < ActiveModel::Serializer
	attributes :id,:lat, :lon, :timestamp, :accuracy
end
