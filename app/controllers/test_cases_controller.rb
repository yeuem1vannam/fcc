class TestCasesController < BaseController
  before_filter :load_contest, only: [:show]
  before_filter :load_problem, only: [:show]
  before_filter :check_opening_contest, only: [:show]

  def show
    @test_case = @problem.test_cases.find params[:id]
  end

  private
  def load_contest
    @contest = Contest.find params[:contest_id]
  end

  def load_problem
    @problem = @contest.problems.find params[:problem_id]
  end

  def check_opening_contest
    ## TODO check opening contest
  end
end
