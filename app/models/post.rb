class Post < ApplicationRecord
  
  belongs_to :cohort
  belongs_to :author, class_name: "User"
end
