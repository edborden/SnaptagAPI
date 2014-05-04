class HuntLocationOnlySerializer < ActiveModel::Serializer
	attributes :latitude, :longitude, :completed_at
end