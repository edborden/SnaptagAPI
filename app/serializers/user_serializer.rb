class UserSerializer < ApplicationSerializer
	attributes :exposed_count, :activated_at
	has_many :locations, embed_in_root: true

	def locations
		[object.locations.last]
	end
end