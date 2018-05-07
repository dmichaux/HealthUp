class StaticPagesController < ApplicationController

	def home
	end

	def help
	end

	def contact
		@message = Message.new
	end
end
