class Test

	def web
		ed = User.find_by(lastname: "Borden")
		queue = Activationqueue.create
		11.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:web_test_user, id: n)) }
	end

end
