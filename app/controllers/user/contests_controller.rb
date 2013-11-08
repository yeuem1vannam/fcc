class User::ContestsController < User::BaseUserController
  def index
    @contests = Contest.page(params[:page]).per(Settings.pagination.contests.index)
  end

  def show
    @contest = Contest.find params[:id]
    @problems = @contest.problems.desc_rank.page(params[:page]).per(Settings.pagination.contests.show.problems)
  end
end
