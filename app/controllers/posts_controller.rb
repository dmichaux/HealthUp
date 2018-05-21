class PostsController < ApplicationController

	before_action :require_login
	before_action :require_admin

	def create
		@cohort = Cohort.find(params[:post][:cohort_id])
		@post = Post.new(post_params)
		if @post.save
			flash[:success] = "Post has been created"
			redirect_to @cohort
		else
			flash.now[:warning] = "Error with post. Expand 'New Post' form for details."
			render 'cohorts/show'
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
