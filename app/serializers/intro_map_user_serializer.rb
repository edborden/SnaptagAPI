class IntroMapUserSerializer < ActiveModel::Serializer
	attributes :exposed_count
	has_many :locations

	def locations
		object.latest_location
	end
end