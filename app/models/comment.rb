class Comment < ApplicationRecord

  belongs_to :post
  belongs_to :author, class_name: "User"

  default_scope -> { order(created_at: :desc) }

  validates :body, 			presence: true, length: { within: 3..500 }
  validates :author_id, presence: true
  validates :post_id, 	presence: true
end
