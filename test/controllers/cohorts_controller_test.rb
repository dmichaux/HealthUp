require 'test_helper'

class CohortsControllerTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:adam)
		@cohort = @user.create_cohort(name: "Test", description: "Test group")
		log_in_as @user
	end

	test "must be admin to get index" do
		assert @user.admin?
		get cohorts_path
		assert_response :success
		@user.toggle!(:admin)
		assert_not @user.admin?
		get cohorts_path
		assert_redirected_to root_path
	end

	test "must be logged in to get show" do
		delete logout_path
		get cohort_path @cohort
		assert_redirected_to login_path
	end

	test "show redirects if neither participant nor admin" do
		@user.toggle!(:admin)
		assert_not @user.admin?
		@user.update_column(:cohort_id, nil)
		assert_not_equal @user.cohort, @cohort
		get cohort_path @cohort
		assert_redirected_to root_path
	end

	test "show allowed for admin, even though not a participant" do
		assert @user.admin?
		@user.update_column(:cohort_id, nil)
		assert_not_equal @user.cohort, @cohort
		get cohort_path @cohort
		assert_response :success
		assert_template "cohorts/show"
	end

	test "show allowed for participant, even though not an admin" do
		@user.toggle!(:admin)
		assert_not @user.admin?
		assert_equal @user.cohort, @cohort
		get cohort_path @cohort
		assert_response :success
		assert_template "cohorts/show"
	end
end
