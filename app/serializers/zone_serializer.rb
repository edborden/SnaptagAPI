class ZoneSerializer < ActiveModel::Serializer
	attributes :id, :lat, :lon, :range, :active

	def active
		if object.active?
			return true
		else
			return false
		end
	end
end
