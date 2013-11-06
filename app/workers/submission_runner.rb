class SubmissionRunner
  @queue = :submission_runner_queue

  def self.perform submission_id
    submission = Submission.find submission_id
    submission.run!
  end
end
