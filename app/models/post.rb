class Post < ApplicationRecord
  
  belongs_to :cohort
  belongs_to :author, class_name: "User"

  default_scope -> { order(created_at: :desc) }

  validates :title, 		presence: true, length: { within: 2..50 }
  validates :body, 			presence: true, length: { within: 5..3000 }
  validates :cohort_id, presence: true
  validates :author_id, presence: true
end
