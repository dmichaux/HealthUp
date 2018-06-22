class Cohort < ApplicationRecord

	has_many :users, dependent: :nullify
	has_many :posts, dependent: :destroy
	has_many :goals, dependent: :destroy, class_name: "CohortGoal"
	
	accepts_nested_attributes_for :goals

	validates :name,				presence: true, length: { within: 3..25 }
	validates :description, presence: true, length: { within: 3..500 }

	def starts
		if start_date
			start_date.strftime('%A, %-m/%-d/%Y')
		else
			"unspecified"
		end
	end

	def ends
		if end_date
			end_date.strftime('%A, %-m/%-d/%Y')
		else
			"unspecified"
		end
	end

	# Sends a message to all cohort participants
	def notify_participants(message, author_id)
		self.users.each do |user|
			Message.create(body: message, to_user_id: user.id, from_user_id: author_id)
		end
	end
end
