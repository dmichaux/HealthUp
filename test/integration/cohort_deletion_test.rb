require 'test_helper'

class CohortDeletionTest < ActionDispatch::IntegrationTest
  
  def setup
  	@cohort = cohorts(:one)
  	@user 	= users(:adam)
  	log_in_as @user
  end

  test "must be logged in to delete cohort" do
  	delete logout_path
  	assert_no_difference "Cohort.count" do
  		delete cohort_path(@cohort)
  	end
  	assert_redirected_to login_path
  end

  test "must be admin to delete cohort" do
  	@user.toggle!(:admin)
  	assert_not @user.admin?
  	assert_no_difference "Cohort.count" do
  		delete cohort_path(@cohort)
  	end
  	assert_redirected_to root_path
  end

  test "successful cohort deletion" do
  	assert_difference "Cohort.count", -1 do
  		delete cohort_path(@cohort)
  	end
  	assert_redirected_to cohorts_path
  end
end
