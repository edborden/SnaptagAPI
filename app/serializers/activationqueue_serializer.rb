class ActivationqueueSerializer < ApplicationSerializer
	attributes :users_count
	has_one :zone, embed_in_root: true
end
