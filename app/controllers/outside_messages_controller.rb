class OutsideMessagesController < ApplicationController

	def new
		@outside_message = OutsideMessage.new
	end

	def create
	end
end
