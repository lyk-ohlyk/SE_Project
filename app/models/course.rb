class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy

  validates :course_name, presence: true
  #
  # def new_ass!(assignment)
  #
  # end



end
