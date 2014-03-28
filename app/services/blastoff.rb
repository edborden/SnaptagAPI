class Blastoff

	def initialize(activationqueue)
		@need_hunters_list = activationqueue.shuffle
		@need_targets_list = activationqueue.shuffle
		@need_givers_list = activationqueue.shuffle
		@need_receivers_list = activationqueue.shuffle.in_groups(2)
	end

	def run
		#assign hunts
		@need_targets_list.each do |hunter|
			3.times { 
				@need_hunters_list.shuffle
				@need_hunters_list = assign_a_target(hunter,@need_hunters_list) 
			}
		end
		#assign webs
		#first half assigns 6 webs
		@need_receivers_list[0].each do |giver|
			6.times { 
				@need_givers_list.shuffle
				@need_givers_list = assign_a_receiver(giver,@need_givers_list) 
			}
		end

		#second half assigns 5 webs
		@need_receivers_list[1].each do |giver|
			5.times { 
				@need_givers_list.shuffle
				@need_givers_list = assign_a_receiver(giver,@need_givers_list) 
			}
		end

	end

	def assign_a_target(hunter,list)
		validated_target = find_a_valid_target_in_list(hunter,list)
		Hunt.create(:hunter_id => hunter.id, :target_id => validated_target.id)
		list = take_target_off_list_if_has_enough_hunters(validated_target,list)
		return list
	end

	def find_a_valid_target_in_list(hunter,list)
		position = 0
		## target can't be same as hunter and no duplicate targets
		position += 1 until hunter != list[position] && !hunter.targets.reload.include?(list[position])
		return list[position]
	end

	def take_target_off_list_if_has_enough_hunters(validated_target,list)
		if validated_target.hunters_count == 3
			index = list.index(validated_target)
			list.delete_at(index)
		end
		return list
	end

	def assign_a_receiver(giver,list)
		validated_receiver = find_a_valid_receiver_in_list(giver,list)
		Web.create(:giver_id => giver.id, :receiver_id => validated_receiver.id)
		list = take_receiver_off_list_if_has_enough_givers(validated_receiver,list)
		return list
	end

	def find_a_valid_receiver_in_list(giver,list)
		position = 0
		## receiver can't be same as giver and no duplicate receivers
		position += 1 until giver != list[position] && !giver.receivers.reload.include?(list[position])
		return list[position]
	end

	def take_receiver_off_list_if_has_enough_givers(validated_receiver,list)
		if validated_receiver.givers_count == 6
			index = list.index(validated_receiver)
			list.delete_at(index)
		end
		return list
	end

end