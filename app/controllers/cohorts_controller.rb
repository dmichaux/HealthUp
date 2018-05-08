class CohortsController < ApplicationController

	before_action :require_login
	before_action :require_admin, except: :show

	def index
		@cohorts = Cohort.all
	end

	def show
		@cohort = Cohort.find(params[:id])
	end

	def new
		@cohort = Cohort.new
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
