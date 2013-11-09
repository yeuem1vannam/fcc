class Submission < ActiveRecord::Base
  VALID_REGEX = /(?<output>[^\[]+)\[TIME:(?<used_time>[^\]]*)ms\]\[MEMORY:(?<used_memory>[^\]]*)KB\]/
  SUBMISSIONS_DIR = Settings.submissions_dir
  TEST_CASES_DIR = Problem::TEST_CASES_DIR

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
  scope :accepted, ->{where result_status: 'Accepted'}
  scope :unaccepted, ->{where.not result_status: 'Accepted'}
  scope :finished, ->{where state: 'finished'}

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
    used_time = 0;
    used_memory = 0;

    begin
      problem.test_cases.each_with_index do |test_case,index|
        res = Timeout::timeout(problem.limited_time/1000.0) {`bin/run_code.sh #{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}/#{id}/#{file_name} #{Settings.accepted_languages[language]} #{test_case[:input]}`}.chomp
        output = res.match(VALID_REGEX).try :[], :output
        used_time = [res.match(VALID_REGEX).try(:[], :used_time).to_i, used_time].max
        used_memory = [res.match(VALID_REGEX).try(:[], :used_memory).to_i, used_memory].max
        if output
          if used_memory > problem.limited_memory
            result = 'Limited memory exceeded'
            break
          elsif output == File.read("#{test_case[:output]}").chomp
            update last_passed_test_case: index + 1
          else
            result = 'Wrong Answer'
            break
          end
        else
          result = case res
                   when '[ERROR][RUNTIME]'
                     'Runtime Error'
                   when '[ERROR][COMPILE]'
                     'Compile Error'
                   end
          break
        end
      end
    rescue
      result = 'Limited time exceeded'
    end

    if (result == 'Accepted') && !user.solved?(problem)
      problem.add_point self
    end

    update used_time: used_time
    update used_memory: used_memory
    update result_status: result
    finish!
  end

  def receive_point point
    update received_point: point
    user.user_scores.in_contest(problem.contest).first_or_initialize.add_point point
  end

  def wrong_answer_decreased_point
    user.submissions.of_problem(problem).finished.unaccepted.count * problem.wrong_answer_decreased_point
  end

  def slowly_decreased_point
    ((created_at - problem.contest.start_at) / problem.slowly_decreased_interval).round
  end

  def accepted?
    result_status == 'Accepted'
  end

  def source_code
    File.read("#{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}/#{id}/#{file_name}").html_safe
  end

  private
  def check_opening_contest
    unless problem.try(:contest).try(:opening?)
      errors.add(:contest, 'Contest ended')
    end
  end

  def save_attached_file
    if attached_file.tempfile.size > problem.limited_source_size
      errors.add(:problem, 'Limited source size exceeded')
    else
      Dir.mkdir(SUBMISSIONS_DIR) unless Dir.exist?(SUBMISSIONS_DIR)
      Dir.mkdir("#{SUBMISSIONS_DIR}/#{user_id}") unless Dir.exist?("#{SUBMISSIONS_DIR}/#{user_id}")
      Dir.mkdir("#{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}") unless Dir.exist?("#{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}")
      Dir.mkdir("#{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}/#{id}") unless Dir.exist?("#{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}/#{id}")
      directory = "#{SUBMISSIONS_DIR}/#{user_id}/#{problem_id}/#{id}"
      path = File.join(directory, file_name)
      File.open(path, "wb") { |f| f.write(attached_file.tempfile.read) }
    end
  end

  def runner_enqueue
    Resque.enqueue SubmissionRunner, id
  end

  def file_name
    if Settings.accepted_languages[language].to_sym.in? Settings.special_language_files.to_hash.keys
      Settings.special_language_files.send(Settings.accepted_languages[language])
    else
      id.to_s
    end + Settings.language_extensions[language]
  end
end
