class Test

	def web
		ed = User.find_by(lastname: "Borden")
		queue = Activationqueue.create
		11.times { |n| instance_variable_set("@user" + (n+25).to_s, Fabricate(:web_test_user, id: (n+25))) }
	end

	def active_users
		25.times { |n| instance_variable_set("@user" + (n+125).to_s, Fabricate(:active_test_user, id: (n+125))) }
end
