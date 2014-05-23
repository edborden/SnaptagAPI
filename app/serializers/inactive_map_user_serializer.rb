class InactiveMapUserSerializer < ActiveModel::Serializer
	attributes :id, :exposed_count
	has_many :locations
	has_one :zone, embed :ids, include: true

#	def locations
#		object.locations.first
#	end
end