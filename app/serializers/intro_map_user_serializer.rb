class IntroMapUserSerializer < ActiveModel::Serializer
	embed :ids, include: true
	attributes :id, :exposed_count
	has_many :locations

#	def locations
#		object.latest_location
#	end
end