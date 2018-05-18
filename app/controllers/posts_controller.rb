class PostsController < ApplicationController

	before_action :require_login
	before_action :require_admin

	def create
		@post = Post.new(post_params)
		if @post.save
			flash[:success] = "Post has been created"
			redirect_to cohort_path params[:cohort_id]
		else
			render :new
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def post_params
		params.require(:post).permit(:title, :body, :cohort_id, :author_id)
	end
end
