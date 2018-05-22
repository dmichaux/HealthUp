class CommentsController < ApplicationController

	before_action :require_login
	before_action :require_author_or_admin, only: :destroy

	def create
		@post = Post.find(params[:comment][:post_id])
		@cohort = Cohort.find(@post.cohort_id)
		@comment = @post.comments.build(comment_params)
		if @comment.save
			flash[:success] = "Comment added"
			redirect_to @cohort
		else
			flash.now[:danger] = "Error with comment. Expand post again for details."
			render 'cohorts/show'
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
