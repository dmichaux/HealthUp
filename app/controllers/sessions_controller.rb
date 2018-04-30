class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			log_in user
			flash[:notice] = "Login Successful"
			redirect_to root_path
		else
			flash.now[:notice] = "Invalid login credentials"
			render :new
		end
	end

	def destroy
	end
end
