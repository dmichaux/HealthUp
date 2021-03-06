class Message < ApplicationRecord

	belongs_to :from_user, class_name: "User"
	belongs_to :to_user, 	 class_name: "User"

	default_scope -> { order(created_at: :desc) }

	validates :to_user_id, presence: true
	validates :body, 			 presence: true, length: { within: 1..3000 }

	def open_message
		toggle!(:opened)
	end
end
