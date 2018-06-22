class UsersController < ApplicationController

	before_action :require_login
	before_action :require_admin, 			 		 except: [:show, :edit, :update, :messages]
	before_action :require_current_user, 		 only: 	 [:edit, :update, :messages]
	before_action :require_deactivated_user, only: 	 :reactivate

	def index
		@active 		  = User.includes(:cohort).where(activated: true)
		@unactivated  = User.without_deleted.where(activated: false)
		@soft_deleted = User.only_deleted
	end

	def show
		@user = User.find(params[:id])
		if current_user?(@user)
			@user_goal 		 			= UserGoal.new
			@new_message_count  = @user.new_message_count
		else
			@message = Message.new
		end
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params_create)
		if @user.save
			@user.send_activation_email
			flash[:success] = "Account activation email sent to client"
			redirect_to current_user
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params_update)
			flash[:success] = "Information updated"
			redirect_to @user
		else
			render :edit
		end
	end

	def unassign_cohort
		@user = User.find(params[:id])
		@user.unassign_cohort
		flash[:success] = "User removed from cohort"
		redirect_back fallback_location: @user
	end

	def soft_delete
		User.find(params[:id]).soft_delete
		flash[:success] = "User archived and marked for deletion"
		redirect_to users_path
	end

	def reactivate
		@user.reactivate
		flash[:success] = "Reactivation email sent to client"
		redirect_to users_path
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User permanently deleted"
		redirect_to users_path
	end

	def destroy_soft_deleted
		User.only_deleted.destroy_all
		flash[:success] = "All archived users permanently deleted"
		redirect_to users_path
	end

	def messages
		@sent 							= Message.includes(:to_user).where(from_user_id: @user.id)
		@received 					= Message.includes(:from_user).where(to_user_id: @user.id)
		@received_unopened  = @received.where(opened: false).count
		if @user.admin?
			@outside 					= OutsideMessage.where(to_admin_id: @user.id)
			@outside_unopened = @outside.where(opened: false).count
		end
	end

	private

	# User creates password after activation
	def user_params_create
		params.require(:user).permit(:name, :email)
	end

	def user_params_update
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	# Before Filters

	def require_current_user
		@user = User.find(params[:id])
		redirect_to root_path unless current_user?(@user)
	end

	def require_deactivated_user
		@user = User.find(params[:id])
		redirect_to root_path if @user.activated?
	end
end
