require 'test_helper'

class CohortTest < ActiveSupport::TestCase
  
  def setup
  	@cohort = Cohort.new(name: "Test",
  											 description: "A trial group of volunteer users")
  end

  test "should be valid" do
  	assert @cohort.valid?
  end

  test "name should be present" do
    @cohort.name = ""
    assert_not @cohort.valid?
  end

  test "name should be 3 - 25 characters long" do
    @cohort.name = "XX"
    assert_not @cohort.valid?
    @cohort.name = ("X" * 26)
    assert_not @cohort.valid?
  end

  test "description should be present" do
    @cohort.description = ""
    assert_not @cohort.valid?
  end

  test "description should be 3 - 500 characters long" do
    @cohort.description = "XX"
    assert_not @cohort.valid?
    @cohort.description = ("X" * 501)
    assert_not @cohort.valid?
  end
end
