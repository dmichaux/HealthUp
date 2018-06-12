class CommentsController < ApplicationController

	before_action :require_login
	before_action :require_author_or_admin, only: :destroy

	def create
		@post = Post.find(params[:comment][:post_id])
		@cohort = Cohort.find(@post.cohort_id)
		@comment = @post.comments.build(comment_params)
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @cohort, success: "Comment added" }
				format.js
			else
				format.html { render 'cohorts/show',
											danger: "Error with comment. Expand post again for details." }
			end
		end
	end

	def destroy
		@comment.destroy
		flash[:success] = "Comment deleted"
		redirect_back fallback_location: root_path
	end

	private

	def comment_params
		params.require(:comment).permit(:body, :author_id)
	end

	# Before Filters

	def require_author_or_admin
		@comment = Comment.find(params[:id])
		author 	 = (@comment.author == current_user) ? true : false
		unless author || current_user.admin?
			redirect_to root_path
		end
	end
end
