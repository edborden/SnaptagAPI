class HuntsController < ApplicationController
  def create(hunter_id, target_id)
    Hunt.create(:hunter_id => hunter_id, :relation_id => relation_id)
  end
  
  def destroy
    @hunt = current_user.hunts.find(params[:id])
    @hunt.destroy
    flash[:notice] = "Removed relationship."
    redirect_to current_user
    fill_holes
  end

  def fill_holes
    if User.active.need_hunters.count > 2 & User.active.need_targets.count > 2 
      @gonna_hunt_these = User.active.need_hunters.take(3)
      @gonna_get_targeted_by_these = User.active.need_targets.take(3)
      @gonna_hunt_these.each do |v|
        create(current_user.user_id, v.id)
      end
      @gonna_get_targeted_by_these.each do |v|
        create(v.id, current_user.id)
      end  
    end
  end  
  