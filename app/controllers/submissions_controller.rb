class SubmissionsController < BaseController
  before_filter :load_problem, only: [:create]
  before_filter :check_opening_contest, only: [:create]

  def index
    @submissions = current_user.submissions.page(params[:page]).per(Settings.pagination.contests.index)
  end

  def create
    @submission = current_user.submissions.new submission_params
    if @submission.save
      redirect_to contest_problem_path(@problem.contest, @problem), notice: "Submission was created successfully"
    else
      redirect_to contest_problem_path(@problem.contest, @problem), notice: "Submission was created unsuccessfully"
    end
  end

  private
  def load_problem
    @problem = Problem.find params[:submission][:problem_id]
  end

  def submission_params
    ## TODO permit upload file or content
    params.require(:submission).permit(:problem_id, :language, :attached_file)
  end

  def check_opening_contest
    redirect_to :index unless @problem.contest.opening?
  end
end
