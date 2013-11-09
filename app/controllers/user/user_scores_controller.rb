class User::UserScoresController < User::BaseUserController
  before_filter :load_contest, only: [:index]

  def index
    @total_scores = UserScore.select('user_id').group('user_id').sum('point').sort_by{|user_id,total_score| total_score}.reverse
    @user_scores = UserScore.in_contest(@contest).page(params[:page]).per(Settings.pagination.user_scores.index)
  end

  private
  def load_contest
    @contest = Contest.find_by_id params[:contest_id]
  end
end
