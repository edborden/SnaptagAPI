class GameHealer

  def initialize zone
    @zone = zone
  end

  def run
    # is there an activationqueue
    activationqueue = Activationqueue.find_by_zone_id(@zone.id)
    if activationqueue

      # run HuntsHoleFiller as many times as possible on queue
      hole_filler_ran = HuntsHoleFiller.new(@zone.users.active, activationqueue.users).run
      until activationqueue.destroyed? || !hole_filler_ran
        hole_filler_ran = HuntsHoleFiller.new(@zone.users.active, activationqueue.users).run
      end

      if activationqueue.destroyed?
        # then run as many times internally to the zone as proportionally appropriate
        fill_internal_holes
      end

    else
      fill_internal_holes
    end
    
  end

  def fill_internal_holes

    last_man_standing = @zone.users.need_stalkers.count == 1 && @zone.users.need_targets.count == 1 && @zone.users.need_stalkers.first.id == @zone.users.need_targets.first.id
    unless last_man_standing

      # run for users that have no hunters
      until @zone.users(true).need_stalkers.where(stalkers_count: 0).count == 0
        target = @zone.users.need_stalkers.where(stalkers_count: 0).first
        stalkers = @zone.users.need_targets - [target]
        stalker = stalkers.first
        Hunt.create stalker_id: stalker.id, target_id: target.id
      end

      # run for users that have no targets
      until @zone.users(true).need_targets.where(targets_count: 0).count == 0
        stalker = @zone.users.need_targets.where(targets_count: 0).first
        targets = @zone.users.need_stalkers - [stalker]
        target = targets.first
        Hunt.create stalker_id: stalker.id, target_id: target.id
      end

    end

  end

end