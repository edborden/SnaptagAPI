class Activationqueue < ActiveRecord::Base
	has_many :users, after_add: :blastoff_if_full

	def full?
		true if self.users(true).size == 12
	end

	def blastoff_if_full(user = nil)
		if full?
			Blastoff.new(self.users).run
			self.destroy
		end
	end

end
