require 'test_helper'

class UserGoalCreationTest < ActionDispatch::IntegrationTest
  
  def setup
    @user1 = users(:adam)
    @user2 = users(:beth)
    @goal  = @user1.goals.create(body: "Goal 1")
    log_in_as @user1
  end

  test "must be logged in to add goal" do
    delete logout_path
    assert_not is_logged_in?
    assert_no_difference "UserGoal.count" do
      post user_goals_path, params: { user_goal: { body: "Test Goal" },
                                      user_id: @user1.id }
    end
    assert_redirected_to login_path
  end

  test "cannot add goal to another user" do
    assert_no_difference "UserGoal.count" do
      post user_goals_path, params: { user_goal: { body: "Test Goal" },
                                      user_id: @user2.id }
    end
    assert_redirected_to root_path
  end

  test "successful goal addition" do
    assert_difference "UserGoal.count", 1 do
      post user_goals_path, params: { user_goal: { body: "Test Goal" },
                                      user_id: @user1.id }
    end
    assert_redirected_to @user1
  end

  test "must be logged in to delete goal" do
    delete logout_path
    assert_not is_logged_in?
    assert_no_difference "UserGoal.count" do
      delete user_goal_path @goal, params: { user_id: @goal.user_id }
    end
    assert_redirected_to login_path
  end

  test "cannot delete goal of another user" do
    u2_goal = @user2.goals.create(body: "User 2 Goal")
    assert_no_difference "UserGoal.count" do
      delete user_goal_path u2_goal, params: { user_id: u2_goal.user_id }
    end
    assert_redirected_to root_path
  end

  test "successful goal deletion" do
    assert_difference "UserGoal.count", -1 do
      delete user_goal_path @goal, params: { user_id: @goal.user_id }
    end
    assert_redirected_to @user1
  end
end
