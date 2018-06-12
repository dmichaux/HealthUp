class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.activated?
			if user.authenticate(params[:session][:password])
				log_in user
				params[:session][:remember_me] == "1" ? remember(user) : forget(user)
				flash[:success] = "Login Successful"
				redirect_to user
			end
		else
			flash.now[:danger] = "Invalid or Inactive Account"
			render :new
		end
	end

	def destroy
		log_out if logged_in?
		redirect_to root_path
	end
end
