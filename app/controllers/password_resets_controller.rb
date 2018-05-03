class PasswordResetsController < ApplicationController

	before_action :find_user, 				 only: [:edit, :update]
	before_action :require_valid_user, only: [:edit, :update]
	before_action :check_expiration, 	 only: [:edit, :update]

	def new
	end

	def create
		@user = User.find_by(email: params[:password_reset][:email])
		if @user
			@user.create_reset_digest
			@user.send_password_reset_email
			flash[:notice] = "You will recieve an email with reset instructions"
			redirect_to root_path
		else
			flash.now[:notice] = "Invalid email"
			render :new
		end
	end

	def edit
	end

	def update
		if params[:user][:password].empty?
			@user.errors.add(:password, "can't be empty")
			render :edit
		elsif @user.update_attributes(user_params)
			log_in @user
			@user.update_attribute(:reset_digest, nil)
			flash[:notice] = "Your new password has been saved"
			redirect_to @user
		else
			render :edit
		end
	end

	private

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	#Before filters

	def find_user
		@user = User.find_by(email: params[:email])
	end

	# Confirms a valid user
	def require_valid_user
		unless @user && @user.activated? &&
					 @user.authenticated?(:reset, params[:id])
			redirect_to root_path
		end
	end

	# Checks if reset is expired
	def check_expiration
		if @user.password_reset_expired?
			flash[:notice] = "Password Reset has expired."
			redirect_to new_password_reset_path
		end
	end
end
