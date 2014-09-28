class UserSerializer < ApplicationSerializer
	attributes :exposed_count, :activated_at
	has_one :location, embed_in_root: true

	def location
		object.locations.last
	end
end