class User < ApplicationRecord

	before_save :downcase_email

	validates :name,  presence: true, length: { within: 3..25 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { within: 5..254 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false}

	private

	def downcase_email
		self.email.downcase!
	end
end
