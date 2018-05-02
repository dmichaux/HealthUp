class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activate
			flash[:notice] = "Your account is now active. Please create your password."
			redirect_to user # will redirect_to PasswordResets#edit in the future
		else
			flash[:notice] = "Invalid activation link. Message admin for new link."
			redirect_to root_path
		end
	end
end
