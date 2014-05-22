class UserSerializer < ActiveModel::Serializer
	attributes :id, :name, :exposed_count, :counteract_count, :disavowed_count, :compromised_count, :smallpic, :mediumpic, :largepic, :influence
end
