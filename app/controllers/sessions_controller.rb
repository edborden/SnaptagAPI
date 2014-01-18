class SessionsController < ApplicationController
	def create
	  user = User.from_mobile(params[:id],params[:token])
	  session[:user_id] = user.id
	  session[:token] = user.exchange_token
	  render status: :accepted
	end

	def destroy
	  session[:user_id] = nil
	  render status: :accepted
	end
end