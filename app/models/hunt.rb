class Hunt < ActiveRecord::Base
	belongs_to :hunter, :class_name => "User"
	belongs_to :target, :class_name => "User"

#	before_create :validate_users
	after_create :plus_one 

	def hunter
		hunter ||= User.find(self.hunter_id)
	end

	def target
		target ||= User.find(self.target_id)
	end

	def complete
		self.active = false
		save
		minus_one
	end

	private

		## THIS NEEDS EXCEPTION HANDLING
		#def validate_users
		#	if hunter.reload.targets_count <= 2 and hunter.active? and target.reload.hunters_count <= 2 and target.active?
		#		true
		#	else
		#		false
		#	end
		#end

		def plus_one
			hunter.increment!(:targets_count)
			target.increment!(:hunters_count)
		end

		def minus_one
			hunter.decrement!(:targets_count)
			target.decrement!(:hunters_count)
		end

end
