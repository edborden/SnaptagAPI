class Alerter < ActiveRecord::Base
	belongs_to :user

	def send subject,body
		if platform == "android"
			GoogleCloudHandler.new(reg_id).send_message subject,body
		else
			return
		end
	end

end