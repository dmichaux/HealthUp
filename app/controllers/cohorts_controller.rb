class CohortsController < ApplicationController

	before_action :require_login
	before_action :require_admin, 							 except: :show
	before_action :require_participant_or_admin, only: 	 :show

	def index
		@cohorts = Cohort.all
	end

	def show
	end

	def new
		@cohort = Cohort.new
	end

	def create
		@cohort = Cohort.new(cohort_params)
		if @cohort.save
			flash[:notice] = "Cohort created"
			redirect_to @cohort
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

	def cohort_params
		params.require(:cohort).permit(:name, :description, :start_date, :end_date)
	end

	#Before Filters

	def require_participant_or_admin
		@cohort = Cohort.find(params[:id])
		participant = (current_user.cohort == @cohort) ? true : false
		unless participant || current_user.admin?
			redirect_to root_path
		end
	end
end
