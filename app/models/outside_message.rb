class OutsideMessage < ApplicationRecord

	default_scope -> { order(created_at: :desc) }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { within: 5..254 },
										format: { with: VALID_EMAIL_REGEX }
	validates :name, presence: true, length: { within: 3..25 }
	validates :body, presence: true, length: { within: 1..2000 }
	validates :to_admin_id, presence: true
end
