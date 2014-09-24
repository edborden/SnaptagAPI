class UserSerializer < ApplicationSerializer
	attributes :exposed_count, :activated_at, :lat, :lon
end