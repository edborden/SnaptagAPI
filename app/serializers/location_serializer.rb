class LocationSerializer < ActiveModel::Serializer
	attributes :id,:lat, :lon, :created_at
	has_one :user, embed: :id, include: false
end
