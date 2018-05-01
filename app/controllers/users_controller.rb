class UsersController < ApplicationController

	before_action :admin_user, except: [:show, :edit, :update]

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		# if @user.save
		# 	UserMailer.activation_email(@user).deliver_now
		# 	flash[:notice] = "Activation email sent to client"
		# 	redirect_to current_user
		# else
		# 	flash.now[:notice] = "Invalid name or email"
		# 	render :new
		# end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def user_params
		params.require(:user).permit(:name, :email)
	end
end
