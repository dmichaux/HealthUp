class PostsController < ApplicationController

	before_action :require_login
	before_action :require_admin

	def new
	end

	def create
	end

	def edit
	end

	def update
	end

	def destroy
	end
end
