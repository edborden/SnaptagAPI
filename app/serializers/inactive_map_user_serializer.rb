class InactiveMapUserSerializer < ActiveModel::Serializer
	attributes :id, :exposed_count, :activated_at, :lat, :lon
	has_one :zone, embed_in_root: true

end