require 'test_helper'

class CohortTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:adam)
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

  test "associated posts should be destroyed" do
    @cohort.save
    @post = @cohort.posts.create(title: "Test", body: "Test body",
                                 author_id: @user.id)
    assert_equal @cohort, @post.cohort
    assert_difference "Post.count", -1 do
      @cohort.destroy
    end
  end

  test "associated users' foreign key should be nullified" do
    @cohort.save
    @user.update_column(:cohort_id, @cohort.id)
    assert_equal @cohort, @user.cohort
    @cohort.destroy
    assert_nil @user.reload.cohort
  end
end
