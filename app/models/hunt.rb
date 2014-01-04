class Hunt < ActiveRecord::Base
	belongs_to :hunter, :class_name => "User"
	belongs_to :target, :class_name => "User"

	after_create :plus_one 
	before_destroy :minus_one

	private

	def plus_one
		@user = User.find(self.hunter_id)
		@user.targets_count += 1 
		@user.save
		@relation = User.find(self.target_id)
		@relation.hunters_count += 1
		@relation.save
	end

	def minus_one
		@user = User.find(self.hunter_id)
		@user.targets_count -= 1 
		@user.save
		@relation = User.find(self.target_id)
		@relation.hunters_count -= 1
		@relation.save
	end

end
