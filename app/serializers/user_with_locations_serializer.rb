class UserWithLocationsSerializer < UserSerializer
	has_many :locations
	embed :ids, :include => true
end