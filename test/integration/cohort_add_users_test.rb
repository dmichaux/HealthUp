require 'test_helper'

class CohortAddUsersTest < ActionDispatch::IntegrationTest
  
  def setup
  	@cohort = Cohort.create(name: "Test", description: "Test group.")
  	@user = users(:adam)
  	@user.update_column(:cohort_id, nil)
  	log_in_as @user
  end

  test "must be logged in to add users" do
  	delete logout_path
  	assert_not is_logged_in?
  	get select_users_cohort_path @cohort
  	assert_redirected_to login_path
  	assert_no_difference "@cohort.users.count" do
  		patch add_users_cohort_path @cohort, params: { assigned:
  																								 { user_ids: [@user.id] } }
  	end
  	assert_redirected_to login_path
  end

  test "must be admin to add users" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	get select_users_cohort_path @cohort
  	assert_redirected_to root_path
  	assert_no_difference "@cohort.users.count" do
  		patch add_users_cohort_path @cohort, params: { assigned:
  																								 { user_ids: [@user.id] } }
  	end
  	assert_redirected_to root_path
  end

  test "select_users only displays users with no assigned cohort" do
  	# Unassigned user
  	assert_nil @user.cohort_id
  	get select_users_cohort_path @cohort
  	assert_select "label", text: @user.name
  	# Assigned user
  	@user.update_column(:cohort_id, 4)
  	assert_not_nil @user.cohort_id
  	get select_users_cohort_path @cohort
  	assert_select "label", { text: @user.name, count: 0 }
  end

  test "cannot assign user if already assigned" do
  	@user.update_column(:cohort_id, 4)
  	assert_no_difference "@cohort.users.count" do
  		patch add_users_cohort_path @cohort, params: { assigned:
  																								 { user_ids: [@user.id] } }
  	end
  end

  test "successfully assigning users to cohort" do
  	assert_difference "@cohort.users.count", 1 do
  		patch add_users_cohort_path @cohort, params: { assigned:
  																								 { user_ids: [@user.id] } }
  	end
  	assert_redirected_to cohort_path @cohort
  	follow_redirect!
  	assert_match (/Participants[\s\S]+#{@user.name}/), response.body
  end
end
