class UserSerializer < ActiveModel::Serializer
	attributes :id, :firstname, :lastname, :completed_count, :roll_up_count, :exposed_count, :smallpic, :mediumpic, :largepic
end
