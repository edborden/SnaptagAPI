class UserWithLocationsSerializer < UserSerializer
	embed :ids, include: true
	has_many :locations, key: :locations
end