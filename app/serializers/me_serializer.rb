class MeSerializer < ApplicationSerializer
	attributes :name, :targets_found_count, :found_count, :stalkers_exposed_count, :exposed_count, :stealth, :status, :smallpic, :mediumpic, :largepic
	has_many :suspects, embed_in_root: true, serializer: SuspectSerializer, root: "users"
	has_many :notifications, embed_in_root: true
	has_many :targets

	def notifications
		object.mailbox.notifications.first(9)
	end
		
end
