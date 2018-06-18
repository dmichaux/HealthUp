class UserGoal < ApplicationRecord

	belongs_to :user

	validates :body, 		presence: true, length: { maximum: 250 }
	validates :user_id, presence: true
end
