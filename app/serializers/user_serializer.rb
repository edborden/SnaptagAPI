class UserSerializer < ActiveModel::Serializer
	attributes :id, :name, :exposed_count, :counteract_count, :disavowed_count, :compromised_count, :smallpic, :mediumpic, :largepic, :influence
	has_one :zone, embed_in_root: true

end
