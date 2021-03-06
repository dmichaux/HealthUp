class PostsController < ApplicationController

	before_action :require_login
	before_action :require_admin

	def create
		@cohort = Cohort.find(params[:post][:cohort_id])
		@post = Post.new(post_params_create)
		if @post.save
			@cohort.notify_participants("There's a new post on your cohort page!",
																	params[:post][:author_id].to_i)
			flash[:success] = "Post has been created"
			redirect_to @cohort
		else
			flash.now[:warning] = "Error with post. Expand 'New Post' form for details."
			@comment = Comment.new
			render 'cohorts/show'
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if @post.update_attributes(post_params_update)
			flash[:success] = "Post updated"
			@cohort = Cohort.find(@post.cohort_id)
			redirect_to @cohort
		else
			render :edit
		end
	end

	def destroy
		@post 	= Post.find(params[:id])
		@cohort = Cohort.find(@post.cohort_id)
		@post.destroy
		flash[:success] = "Post deleted"
		redirect_to @cohort
	end

	private

	def post_params_create
		params.require(:post).permit(:title, :body, :cohort_id, :author_id)
	end

	# Updates must not alter cohort_id or author_id
	def post_params_update
		params.require(:post).permit(:title, :body)
	end
end
