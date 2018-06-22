class UserGoalsController < ApplicationController

	before_action :require_login
	before_action :require_current_user

	def create
		@user_goal = @user.goals.build(goal_params)
		respond_to do |format|
			if @user_goal.save
				format.html { redirect_to @user }
				format.js
			else
				@user.goals.delete(@user_goal)
				@new_message_count = @user.new_message_count
				format.html { render 'users/show' }
			end
		end
	end

	def destroy
		@user_goal = UserGoal.find(params[:id])
		@user_goal.destroy
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	private

	def goal_params
		params.require(:user_goal).permit(:body)
	end

	# Before Filter

	def require_current_user
		@user = User.find(params[:user_id])
		redirect_to root_path unless current_user?(@user)
	end
end
