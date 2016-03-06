class MetricsController < ApplicationController

  def index

    metrics = {
      users_count: User.count,
      zones_count: Zone.count,
      active_users: User.active.count,
      completed_hunts: Hunt.completed.count
    }

    render json: metrics

  end

  #def ten

  #  users = User.includes(:session).find params[:ids]
  #  render json: users, each_serializer: TenSerializer, root: "users"

  #end

end