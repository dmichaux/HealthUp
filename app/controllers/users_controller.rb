class UsersController < ApplicationController

	before_action :require_login
	before_action :require_admin, 			 except: [:show, :edit, :update, :messages]
	before_action :require_current_user, only: [:edit, :update, :messages]

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
		@message = Message.new
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
		@sent 		= Message.includes(:to_user).where(from_user_id: @user.id)
		@received = Message.includes(:from_user).where(to_user_id: @user.id)
		@outside  = OutsideMessage.where(to_admin_id: @user.id) if @user.admin?
	end

	private

	def user_params
		params.require(:user).permit(:name, :email)
	end

	# Before Filters

	def require_current_user
		@user = User.find(params[:id])
		redirect_to root_path unless current_user?(@user)
	end
end
