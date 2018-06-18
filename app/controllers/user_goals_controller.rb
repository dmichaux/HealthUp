class UserGoalsController < ApplicationController

	before_action :require_login
	before_action :require_current_user

	def create
		@goal = @user.goals.build(goal_params)
		respond_to do |format|
			if @goal.save
				format.html { redirect_to @user }
				format.js
			else
				format.html { render 'users/show', danger: 'Invalid goal' }
			end
		end
	end

	private

	def goal_params
		params.require(:user_goal).permit(:body)
	end

	# Before Filter

	def require_current_user
		@user = User.find(params[:user_goal][:user_id])
		redirect_to root_path unless current_user?(@user)
	end
end
