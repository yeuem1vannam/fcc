class User::SubmissionsController < User::BaseUserController
  before_filter :check_login
  before_filter :load_problem, only: [:create]
  before_filter :load_submission, only: [:show]
  before_filter :check_submitable, only: [:create]
  before_filter :check_viewable, only: [:show]

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

  def check_submitable
    redirect_to user_contest_problem_path(@problem.contest, @problem) unless @problem.contest.submitable?
  end

  def check_login
    redirect_to user_contests_path unless current_user
  end

  def check_viewable
    redirect_to user_contests_path unless current_user.try(:is_reviewer?) || (@submission.problem.contest.ended? && (current_user == @submission.user))
  end

  def load_submission
    @submission = Submission.find params[:id]
  end
end
