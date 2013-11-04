class User::ProblemsController < User::BaseUserController
  before_filter :load_contest, only: [:show]
  before_filter :load_problem, only: [:show]
  before_filter :load_submissions, only: [:show]
  before_filter :load_test_cases, only: [:show]
  before_filter :setup_submission, only: [:show]

  def show
  end

  private
  def load_contest
    @contest = Contest.find params[:contest_id]
  end

  def load_problem
    @problem = @contest.problems.find params[:id]
  end

  def load_submissions
    @submissions = current_user.submissions.of_problem(@problem.id).page(params[:page]).per(Settings.pagination.problems.show.submissions)
  end

  def load_test_cases
    unless @contest.opening?
      @test_cases = @problem.test_cases.page(params[:page]).per(Settings.pagination.problems.show.test_cases)
    end
  end

  def setup_submission
    if @contest.opening?
      @submission = current_user.submissions.new problem_id: @problem.id
    end
  end
end
