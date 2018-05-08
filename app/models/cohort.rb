class Cohort < ApplicationRecord

	has_many :users

	validates :name,				presence: true, length: { within: 3..25 }
	validates :description, presence: true, length: { within: 3..500 }
end
