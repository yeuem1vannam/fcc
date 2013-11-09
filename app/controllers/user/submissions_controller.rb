class User::SubmissionsController < User::BaseUserController
  before_filter :check_login
  before_filter :check_reviewers, only: [:show]
  before_filter :load_problem, only: [:create]
  before_filter :load_submission, only: [:show]
  before_filter :check_opening_contest, only: [:create]

  def index
    @submissions = if current_user.is_reviewer?
                     Submission.page(params[:page]).per(Settings.pagination.contests.index)
                   else
                     current_user.submissions.page(params[:page]).per(Settings.pagination.contests.index)
                   end
  end

  def create
    @submission = current_user.submissions.new submission_params
    if @submission.save
      redirect_to user_contest_problem_path(@problem.contest, @problem), notice: "Submission was created successfully"
    else
      redirect_to user_contest_problem_path(@problem.contest, @problem), notice: "Submission was created unsuccessfully"
    end
  end

  def show
  end

  private
  def load_problem
    @problem = Problem.find params[:submission][:problem_id]
  end

  def submission_params
    params.require(:submission).permit(:problem_id, :language, :attached_file)
  end

  def check_opening_contest
    redirect_to :index unless @problem.contest.opening?
  end

  def check_login
    redirect_to user_contests_path unless current_user
  end

  def check_reviewers
    redirect_to user_contests_path unless current_user.is_reviewer?
  end

  def load_submission
    @submission = Submission.find params[:id]
  end
end
