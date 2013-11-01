class ProblemsController < BaseController
  def show
    @problem = Problem.find params[:id]
    @submissions = current_user.submissions.where(problem_id: @problem.id).page(params[:page]).per(Settings.pagination.problems.show.submissions)
    ## TODO check ended contest
    @test_cases = @problem.test_cases.page(params[:page]).per(Settings.pagination.problems.show.test_cases)
  end
end
