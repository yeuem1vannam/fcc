class Contest < ActiveRecord::Base
  has_many :problems, dependent: :destroy
  has_many :submissions, through: :problems
end
