class CohortGoal < ApplicationRecord

	belongs_to :cohort

	validates :body, presence: true, length: { maximum: 250 }
end
