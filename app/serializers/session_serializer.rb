class SessionSerializer < ApplicationSerializer
	attributes :token
	has_one :user, embed_in_root: true, serializer: MeSerializer, root: 'user'
end
