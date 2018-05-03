class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activate
			user.create_reset_digest
			flash[:notice] = "Your account is now active. Please create your password."
			redirect_to edit_password_reset_path(user.pass_reset_token, email: user.email)
		else
			flash[:notice] = "Invalid activation link. Message admin for new link."
			redirect_to root_path
		end
	end
end
