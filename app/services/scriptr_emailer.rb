require 'httparty'

class ScriptrEmailer

	def initialize email
		@email = email
		@key = "RDU0OTQ3RDJDNTpzY3JpcHRyOkVDQzBDNURGNDVCMUZGNDFCMTMxNDAwMUFBRkNFMTcx"
	end

	def send_message subject,body
		body = {
			recipient: @email,
			subject: subject,
			body: body + "<p><a href='https://gosnaptag.com'>Snaptag</a></p>"
		}

		options = {
			body: body.to_json,
			headers: {
				"Authorization" => 'bearer ' + @key,
				"content-type" => 'application/json'
			}			
		}

		response = HTTParty.post 'https://api.scriptrapps.io/snaptag/mail', options
	end
end