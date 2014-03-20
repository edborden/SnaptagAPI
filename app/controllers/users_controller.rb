class UsersController < ApplicationController
  before_filter :ensure_authenticated_user, except: [:create]

  # login:
  def create

    user = User.find_by(facebookid: params[:facebookid])

    ## if new user:
    ### exchange for 60 day token
    ### create user, return user

    if user == nil
      new_token = Facebook.new.exchange_token(params[:token])
      user = User.create_from_facebook(new_token)
      render json: user, callback: params[:callback], root: true

    ## if existing user
    ### if tokens match, return user
    ### if tokens don't match, exchange for 60 day token, return user

    else
      if user.token == params[:token]
        render json: user, callback: params[:callback], root: true
      else
        user.token = Facebook.new.exchange_token(params[:token])
        user.save
        render json: user, callback: params[:callback], root: true
  end

  def show
    render json: User.find(params[:id])
  end

  def test
    test = User.find_by(firstname: params[:firstname])
    render json: test, callback: params[:callback], root: true
  end

end