class RelationshipsController < ApplicationController
  def make(user_id, relation_id, relationship_type)
    Relationship.create(:user_id => user_id, :relation_id => relation_id, :relationship_type => relationship_type)
  end
  
  def destroy
    @relationship = current_user.relationships.find(params[:id])
    @relationship.destroy
    flash[:notice] = "Removed relationship."
    redirect_to current_user
    fill_holes
  end

  def fill_holes
    if User.active.need_hunters.count > 2 & User.active.need_targets.count > 2 
      @gonna_hunt_these = User.active.need_hunters.take(3)
      @gonna_get_targeted_by_these = User.active.need_targets.take(3)
      @gonna_hunt_these.each do |v|
        make(current_user.user_id, v.id, hunt)
      end
      @gonna_get_targeted_by_these.each do |v|
        make(v.id, current_user.id, hunt)
      end  
    end
  end  
  