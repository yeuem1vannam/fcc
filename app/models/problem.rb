class Problem < ActiveRecord::Base
  belongs_to :contest
  has_many :submissions, dependent: :destroy
  has_many :test_cases, dependent: :destroy
end
