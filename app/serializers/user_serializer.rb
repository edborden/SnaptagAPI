class UserSerializer < ActiveModel::Serializer
	attributes :id, :firstname, :lastname, :exposed_count, :counteract_count, :compromised_count, :smallpic, :mediumpic, :largepic, :influence
end
