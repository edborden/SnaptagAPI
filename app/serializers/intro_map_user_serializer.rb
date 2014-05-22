class InactiveMapUserSerializer < ActiveModel::Serializer
	embed :zone, include: true

	attributes :id, :exposed_count
	has_many :locations
	belongs_to :zone

	def locations
		object.locations.first
	end
end