class UsersController < ApplicationController

	before_action :require_login
	before_action :require_admin, except: [:show, :edit, :update]

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
		if @user.save
			@user.send_activation_email
			flash[:notice] = "Account activation email sent to client"
			redirect_to current_user
		else
			render :new
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	def messages
		@user 		= User.find(params[:id])
		@sent 		= Message.includes(:to_user).where(from_user_id: @user.id)
		@received = Message.includes(:from_user).where(to_user_id: @user.id)
	end

	private

	def user_params
		params.require(:user).permit(:name, :email)
	end
end
