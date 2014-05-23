class InactiveMapUserSerializer < ActiveModel::Serializer
	attributes :id, :exposed_count, :activated_at
	has_many :locations
	has_one :zone, embed: :id, include: true

#	def locations
#		object.locations.first
#	end
end