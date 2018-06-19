require 'test_helper'

class CohortGoalTest < ActiveSupport::TestCase
  
  def setup
  	cohort = cohorts(:one)
  	@goal  = cohort.goals.build(body: "Goal 1 ...")
  end

  test "should be valid" do
  	assert @goal.valid?
  end

  test "body should be present" do
  	@goal.body = "   "
  	assert_not @goal.valid?
  end

  test "body should not exceed 250 characters" do
  	@goal.body = "x" * 251
  	assert_not @goal.valid?
  end
end
