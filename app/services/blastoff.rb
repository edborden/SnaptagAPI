class Blastoff

	def initialize(activationqueue)
		@need_hunters_list = activationqueue.shuffle
		@need_targets_list = activationqueue.shuffle
	end

	def run
		@need_targets_list.each do |hunter|
			3.times { 
				@need_hunters_list.shuffle
				@need_hunters_list = assign_a_target(hunter,@need_hunters_list) 
			}
		end
	end

	def assign_a_target(hunter,list)
		validated_target = find_a_valid_target_in_list(hunter,list)
		Hunt.create(:hunter_id => hunter.id, :target_id => validated_target.id)
		list = take_target_off_list_if_has_enough_hunters(validated_target,list)
	end

	def find_a_valid_target_in_list(hunter,list)
		position = 0
		## target can't be same as hunter and no duplicate targets
		position += 1 until hunter != list[position] && hunter.targets.include?(list[position])
		return list[position]
	end

	def take_target_off_list_if_has_enough_hunters(validated_target,list)
		list -= list[position] if list[position].huntercount == 3
	end

end