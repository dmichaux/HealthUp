require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  def setup
  	@user = users(:adam)
  	@post = posts(:one)
  	@comment = @post.comments.build(body: "Great post!", author_id: @user.id)
  end

  test "should be valid" do
  	assert @comment.valid?
  end

  test "body must be present" do
		@comment.body = "  "
		assert_not @comment.valid?
	end

	test "body must be within 3 and 500 characters" do
		@comment.body = "xx"
		assert_not @comment.valid?
		@comment.body = "x" * 501
		assert_not @comment.valid?
	end

	test "author_id should be present" do
		@comment.author_id = nil
		assert_not @comment.valid?
	end

	test "post_id should be present" do
		@comment.post_id = nil
		assert_not @comment.valid?
	end

	test "should be ordered with most recent first" do
  	assert_equal comments(:most_recent), Comment.first
  end
end
