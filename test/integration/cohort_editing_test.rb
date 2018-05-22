require 'test_helper'

class CohortEditingTest < ActionDispatch::IntegrationTest
  
  def setup
  	@cohort = cohorts(:one)
  	@user 	= users(:adam)
  	log_in_as @user
  end

  test "must be logged in to edit cohort" do
  	delete logout_path
  	assert_not is_logged_in?
  	get edit_cohort_path(@cohort)
  	assert_redirected_to login_path
  	patch cohort_path(@cohort), params: { cohort: { name: 			 "New Name",
  																									description: "New Description",
  																									start_date:  Date.today,
  																									end_date: 	 Date.tomorrow } }
  	assert_redirected_to login_path
  end

  test "must be admin to edit cohort" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	get edit_cohort_path(@cohort)
  	assert_redirected_to root_path
  	patch cohort_path(@cohort), params: { cohort: { name: 			 "New Name",
  																									description: "New Description",
  																									start_date:  Date.today,
  																									end_date: 	 Date.tomorrow } }
  	assert_redirected_to root_path
  end

  test "invalid name" do
  	patch cohort_path(@cohort), params: { cohort: { name: 			 "",
  																									description: "New Description",
  																									start_date:  Date.today,
  																									end_date: 	 Date.tomorrow } }
  	assert_template "cohorts/edit"
		assert_select "div.text-danger"
  end

  test "invalid description" do
  	patch cohort_path(@cohort), params: { cohort: { name: 			 "New Name",
  																									description: "",
  																									start_date:  Date.today,
  																									end_date: 	 Date.tomorrow } }
  	assert_template "cohorts/edit"
		assert_select "div.text-danger"
  end

  test "successful cohort edit" do
  	new_name 				= "New Cohort Name"
  	new_description = "New cohort description."
  	patch cohort_path(@cohort), params: { cohort: { name: 			 new_name,
  																									description: new_description,
  																									start_date:  Date.today,
  																									end_date: 	 Date.tomorrow } }
  	@cohort.reload
  	assert_equal new_name, @cohort.name
  	assert_equal new_description, @cohort.description
  	assert_redirected_to @cohort
  end
end
