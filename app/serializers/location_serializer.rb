class LocationSerializer < ActiveModel::Serializer
	attributes :id,:latitude, :longitude, :timestamp, :accuracy
end
