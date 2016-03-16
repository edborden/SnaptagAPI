class Alerter < ActiveRecord::Base
	belongs_to :user

	def send_alert subject,body
    case platform
    when "android"
			GoogleCloudHandler.new(reg_id).send_message subject,body
		when "email"
      ScriptrEmailer.new(reg_id).send_message subject,body
		end
	end

end