require 'test_helper'

class UserGoalCreationTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:adam)
  	log_in_as @user
  end

  test "must be logged in to add goal" do
  	delete logout_path
  	assert_not is_logged_in?
  	assert_no_difference "UserGoal.count" do
	  	post user_goals_path, params: { user_goal: { user_id: @user.id,
	  																							 body: "Test Goal" } }
  	end
  	assert_redirected_to login_path
  end

  test "cannot add goal to another user" do
  	user2 = users(:beth)
  	assert_no_difference "UserGoal.count" do
  		post user_goals_path, params: { user_goal: { user_id: user2.id,
  																								 body: "Test Goal" } }
  	end
  	assert_redirected_to root_path
  end

  test "successful goal addition" do
  	assert_difference "UserGoal.count", 1 do
  		post user_goals_path, params: { user_goal: { user_id: @user.id,
  																								 body: "Test Goal" } }
  	end
  	assert_redirected_to @user
  	assert_equal "Test Goal", @user.goals.first.body
  end
end
