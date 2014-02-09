class UsersController < ApplicationController

	def show
		render json: current_user
	end

	def test
		test = User.find_by(firstname: params[:firstname])
		render json: test, callback: params[:callback], root: true
	end

end