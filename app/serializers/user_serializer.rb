class UserSerializer < ApplicationSerializer
  attributes :name, :targets_found_count, :found_count, :stalkers_exposed_count, :exposed_count, :stealth, :facebookid
	has_many :locations, embed_in_root: true

	def locations
		[object.locations.last]
	end
end