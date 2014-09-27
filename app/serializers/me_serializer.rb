class MeSerializer < ApplicationSerializer
	attributes :name, :exposed_count, :counteract_count, :disavowed_count, :compromised_count, :smallpic, :mediumpic, :largepic, :influence, :status
	has_many :suspects, embed_in_root: true, serializer: SuspectSerializer, root: "users"
end