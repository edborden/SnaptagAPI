class RelationshipsController < ApplicationController
  def create
    @relationship = current_user.relationships.build(:relation_id => params[:relation_id])
    if @relationship.save
      flash[:notice] = "Added friend."
      redirect_to root_url
    else
      flash[:error] = "Unable to add friend."
      redirect_to root_url
    end
  end
  
  def destroy
    @relationship = current_user.relationships.find(params[:id])
    @relationship.destroy
    flash[:notice] = "Removed relationship."
    redirect_to current_user
  end
end
