class LocationSerializer < ActiveModel::Serializer
	attributes :latitude, :longitude, :timestamp, :accuracy
end
