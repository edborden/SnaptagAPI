class UserWithLocationsSerializer < UserSerializer
	has_many :locations
end