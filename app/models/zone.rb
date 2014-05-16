class Zone < ActiveRecord::Base
	has_many :locations

	## THIS DOESN'T SCALE
	def self.join_zone
		return
	end

end