class Relationship < ActiveRecord::Base
	belongs_to :user
	belongs_to :relation, :class_name => "User"

	after_create :plus_one 
	before_destroy :minus_one

	private

	def plus_one
		@user = User.find(self.user_id)
		@user.target_count += 1 
		@user.save
		@relation = User.find(self.relation_id)
		@relation.hunter_count += 1
		@relation.save
	end

	def minus_one
		@user = User.find(self.user_id)
		@user.target_count -= 1 
		@user.save
		@relation = User.find(self.relation_id)
		@relation.hunter_count -= 1
		@relation.save
	end

end
