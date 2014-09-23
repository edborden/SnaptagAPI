class UserWithLocationsSerializer < UserSerializer
	has_many :locations, embed_in_root: true
end