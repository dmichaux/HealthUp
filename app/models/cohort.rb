class Cohort < ApplicationRecord

	validates :name,				presence: true, length: { within: 3..25 }
	validates :description, presence: true, length: { within: 3..500 }
end
