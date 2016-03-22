class Join

  def initialize user,location_params

    user.locations.create location_params
    user.activate
    user.reload

    ########
    ########
    #Demo.new.create_activationqueue_around user
    ########
    ########

    activationqueue = Activationqueue.find_by_zone_id(user.zone_id)

    unless activationqueue
      hole_filler = HuntsHoleFiller.new(user.zone.users.active, [user])
      hole_filler.run
      unless hole_filler.ran
        activationqueue = Activationqueue.create(zone_id: user.zone_id)
      end
    end

    if activationqueue
      activationqueue.users<<user
      json_package = UserSerializer.new user
      Pusher.trigger "activationqueue"+activationqueue.id.to_s,"Add user to activationqueue",json_package
      user.notify "Added to queue",nil,activationqueue
    end

  end

end