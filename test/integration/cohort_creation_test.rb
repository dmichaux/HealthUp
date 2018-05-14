require 'test_helper'

class CohortCreationTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:adam)
  	log_in_as @user
  end

  test "must be logged in to create a cohort" do
  	delete logout_path
  	assert_not is_logged_in?
  	get new_cohort_path
  	assert_redirected_to login_path
  	assert_no_difference "Cohort.count" do
  		post cohorts_path, params: { cohort: { name: "Test",
  																					 description: "Test group" } }
  	end
  	assert_redirected_to login_path
  end

  test "non-admins cannot create a cohort" do
  	@user.toggle!(:admin)
  	assert_not @user.admin
  	get new_cohort_path
  	assert_redirected_to root_path
  	assert_no_difference "Cohort.count" do
  		post cohorts_path, params: { cohort: { name: "Test",
  																					 description: "Test group" } }
  	end
  	assert_redirected_to root_path
  end

  test "invalid cohort name" do
  	assert_no_difference "Cohort.count" do
  		post cohorts_path, params: { cohort: { name: "",
  																					 description: "Test group" } }
  	end
  	assert_template "cohorts/new"
		assert_select "div.text-danger"
  end

  test "invalid cohort description" do
  	assert_no_difference "Cohort.count" do
  		post cohorts_path, params: { cohort: { name: "Test",
  																					 description: "" } }
  	end
  	assert_template "cohorts/new"
		assert_select "div.text-danger"
  end

  test "succesful cohort creation" do
  	assert_difference "Cohort.count", 1 do
  		post cohorts_path, params: { cohort: { name: "Test",
  																					 description: "Test group" } }
  	end
  	assert_response :redirect
  	follow_redirect!
  	assert_template "cohorts/show"
  end
end
