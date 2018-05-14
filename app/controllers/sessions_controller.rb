class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.activated?
				log_in user
				params[:session][:remember_me] == "1" ? remember(user) : forget(user)
				flash[:success] = "Login Successful"
				redirect_to user
			else
				note =  "Account must be activated."
				note += "Check your email for an activation link"
				flash[:info] = note
				redirect_to root_path
			end
		else
			flash.now[:danger] = "Invalid login credentials"
			render :new
		end
	end

	def destroy
		log_out if logged_in?
		redirect_to root_path
	end
end
