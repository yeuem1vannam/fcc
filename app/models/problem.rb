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
    point = 0 if contest.ended?
    submission.receive_point point
  end

  def test_cases
    Dir["#{TEST_CASES_DIR}/#{id}/test*"].sort.zip(Dir["#{TEST_CASES_DIR}/#{id}/out*"].sort).map{|test| {input: test[0], output: test[1]}}
  end

  def name_for user = nil
    locale = Settings.multi_language.languages[user ? user.locale : 0]
    name = send('name_' + locale)
    name = send('name_' + Settings.multi_language.default_language) unless name
    name
  end

  def content_for user = nil
    locale = Settings.multi_language.languages[user ? user.locale : 0]
    content = send('content_' + locale)
    content = send('content_' + Settings.multi_language.default_language) unless content
    content
  end
end
