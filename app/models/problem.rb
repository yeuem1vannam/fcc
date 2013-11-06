class Problem < ActiveRecord::Base
  belongs_to :contest
  has_many :submissions, dependent: :destroy
  has_many :test_cases, dependent: :destroy

  def difficult
    Settings.problem_ranks[rank]
  end

  def add_point submission
    point = [starting_point - submission.wrong_answer_decreased_point - submission.slowly_decreased_point, 0].max
    submission.receive_point point
  end
end
