class InactiveMapUserSerializer < ActiveModel::Serializer
	embed :zone, include: true

	attributes :id, :exposed_count
	has_many :locations
	has_one :zone

	def locations
		object.locations.first
	end
end