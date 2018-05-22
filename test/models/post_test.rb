require 'test_helper'

class PostTest < ActiveSupport::TestCase

	def setup
		@user = users(:adam)
		@cohort = cohorts(:one)
		@post = @user.posts.build(title: "Test Post", body: "Lorem ipsum...",
															cohort_id: @cohort.id)
	end

	test "should be valid" do
		assert @post.valid?
	end

	test "title must be present" do
		@post.title = "  "
		assert_not @post.valid?
	end

	test "title must be within 2 and 50 characters" do
		@post.title = "x"
		assert_not @post.valid?
		@post.title = "x" * 51
		assert_not @post.valid?
	end

	test "body must be present" do
		@post.body = "  "
		assert_not @post.valid?
	end

	test "body must be within 5 and 3000 characters" do
		@post.body = "x" * 4
		assert_not @post.valid?
		@post.body = "x" * 3001
		assert_not @post.valid?
	end

	test "cohort_id should be present" do
		@post.cohort_id = nil
		assert_not @post.valid?
	end

	test "author_id should be present" do
		@post.author_id = nil
		assert_not @post.valid?
	end

	test "should be ordered with most recent first" do
  	assert_equal posts(:most_recent), Post.first
  end

  test "associated comments should be destroyed" do
  	@post.save
  	@comment = @post.comments.create(body: "test comment.",
  																	 author_id: @user.id)
  	assert_difference "Comment.count", -1 do
  		@post.destroy
  	end
  end
end
