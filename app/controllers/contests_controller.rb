class ContestsController < BaseController
  def index
    @contests = Contest.order("created_at desc").page(params[:page]).per(Settings.pagination.contests.index)
  end

  def show
    @contest = Contest.find params[:id]
    @problems = @contest.problems.page(params[:page]).per(Settings.pagination.contests.show.problems)
  end
end
