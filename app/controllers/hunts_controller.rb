class HuntsController < AuthenticatedController

  def show
    hunt = Hunt.find params[:id]
    render json: hunt
  end

end
