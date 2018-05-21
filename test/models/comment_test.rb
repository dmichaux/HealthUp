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
end
