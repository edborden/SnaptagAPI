class SessionsController < AuthenticatedController
	skip_before_action :ensure_authenticated_user, except: [:destroy, :show]

	def create
		facebook = Facebook.new params[:session][:token]
		token = facebook.exchange_token
		user = User.find_by_facebookid facebook.facebookid
		user = facebook.create_user unless user

		unless user.alerter
			## create email alerter
			Alerter.create user_id: user.id, reg_id: user.email, platform: 'email'

			## create mobile alerter
			reg_id = params[:session][:reg_id]
			platform = params[:session][:platform]
			if reg_id && platform
				Alerter.create user_id:user.id,reg_id:reg_id,platform:platform
			end
		end

		WebsHoleFiller.new(user).run if user.active
		user.session.destroy if user.session.present?
		session = user.create_session token: token		
		render json: session, scope: user
	end

	def show
		render json: current_session, scope: current_user
	end

	def index
		session = Session.find_by_token params[:token]
		if session
			user = session.user
			WebsHoleFiller.new(user).run if user.active
			render json: [session], scope: user
		else
			head :unauthorized
		end
	end

	def destroy
		current_user.session.destroy
		head :no_content
	end

end
