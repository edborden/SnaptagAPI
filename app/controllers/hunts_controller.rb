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

end  