class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem

  attr_accessor :attached_file

  validates :language, presence: true
  validates :problem_id, presence: true
  validates :user_id, presence: true
  validates :attached_file, presence: true, on: :create
  validate :check_opening_contest

  after_create :save_attached_file
  after_save :runner_enqueue

  default_scope ->{order 'created_at DESC'}
  scope :of_problem, ->problem_id{where problem_id: problem_id}

  state_machine :state, initial: :queued do
    event :run do
      transition :queued => :running
    end

    event :finish do
      transition :running => :finished
    end

    after_transition :queued => :running do |submission, transition|
      submission.compile_and_run
    end
  end

  def compile_and_run
    result = 'Accepted'

    problem.test_cases.each_with_index do |test_case,index|
      res = `bin/run_code.sh 'tmp/submissions/#{user_id}/#{problem_id}/#{id}' #{Settings.accepted_languages[language]} #{problem.limited_memory} "#{test_case.input}"`
      ## TODO
      # update last_passed_test_case
      # update result_status
      # check memory
      # check time
      # add point (create model user_score)
    end

    update result_status: result
    finish!
  end

  private
  def check_opening_contest
    unless problem.try(:contest).try(:opening?)
      errors.add(:contest, 'Contest ended')
    end
  end

  def save_attached_file
    Dir.mkdir("tmp/submissions") unless Dir.exist?("tmp/submissions")
    Dir.mkdir("tmp/submissions/#{user_id}") unless Dir.exist?("tmp/submissions/#{user_id}")
    Dir.mkdir("tmp/submissions/#{user_id}/#{problem_id}") unless Dir.exist?("tmp/submissions/#{user_id}/#{problem_id}")
    directory = "tmp/submissions/#{user_id}/#{problem_id}/"
    path = File.join(directory, id.to_s)
    File.open(path, "wb") { |f| f.write(attached_file.tempfile.read) }
  end

  def runner_enqueue
    Resque.enqueue SubmissionRunner, id
  end
end
