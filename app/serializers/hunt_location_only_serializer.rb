class HuntLocationOnlySerializer < ActiveModel::Serializer
	attributes :lat, :lon, :completed_at
end