class Blastoff

	def initialize(activationqueue=[])
		@master_list = activationqueue.shuffle
		@master_list_split = @master_list.in_groups(2)
		@need_targets_list = activationqueue.shuffle
		@need_hunters_list = activationqueue.shuffle
	end

	def run
		@master_list_split[0].each do |user|
			assign_giver(user,@master_list) until user.reload.givers_count == 6
			assign_receiver(user,@master_list) until user.reload.receivers_count == 5
			@master_list -= [user]
		end

		@master_list.each do |user|
			assign_giver(user,@master_list) until user.reload.givers_count == 5
			assign_receiver(user,@master_list) until user.reload.receivers_count == 6
			@master_list -= [user]
		end

		@need_targets_list.each do |hunter|
			3.times { 
				@need_hunters_list.shuffle
				@need_hunters_list = assign_a_target(hunter,@need_hunters_list) 
			}
		end
	end

	def assign_a_target(hunter,list)
		validated_target = find_a_valid_target_in_list(hunter,list)
		Hunt.create(hunter_id: hunter.id, target_id: validated_target.id)
		list -= [validated_target] if validated_target.hunters_count == 3
		return list
	end

	def find_a_valid_target_in_list(hunter,list)
		position = 0
		## target can't be same as hunter and no duplicate targets
		position += 1 until hunter != list[position] && !hunter.targets.include?(list[position])
		return list[position]
	end

	def assign_giver(receiver,list)
		validated_giver = find_a_valid_web_target_in_list(receiver,list)
		Web.create(giver_id: validated_giver.id, receiver_id: receiver.id)
	end

	def assign_receiver(giver,list)
		validated_receiver = find_a_valid_web_target_in_list(giver,list)
		Web.create(giver_id: giver.id, receiver_id: validated_receiver.id)
	end

	def find_a_valid_web_target_in_list(user,list)
		position = 0
		position += 1 until user != list[position] && !user.receivers.include?(list[position]) && !user.givers.include?(list[position])
		return list[position]
	end

end