class Problem < ActiveRecord::Base
  TEST_CASES_DIR = Settings.test_cases_dir

  scope :desc_rank, ->{order 'rank desc'}

  belongs_to :contest
  has_many :submissions, dependent: :destroy

  def difficult
    Settings.problem_ranks[rank]
  end

  def add_point submission
    point = [starting_point - submission.wrong_answer_decreased_point - submission.slowly_decreased_point, 0].max
    submission.receive_point point
  end

  def test_cases
    Dir["#{TEST_CASES_DIR}/#{id}/test*"].sort.zip(Dir["#{TEST_CASES_DIR}/#{id}/out*"].sort).map{|test| {input: test[0], output: test[1]}}
  end
end
