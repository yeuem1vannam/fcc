class SubmissionsController < BaseController
  before_filter :load_contest, only: [:show, :new, :create]
  before_filter :load_problem, only: [:show, :new, :create]
  before_filter :check_opening_contest, only: [:new, :create]

  def show
    @submission = current_user.submissions.find params[:id]
  end

  def new
    @submission = current_user.submissions.new problem_id: @problem.id
  end

  def create
    @submission = current_user.submissions.new submission_params
    if @submission.save
      redirect_to contest_problem_submission_path(@contest, @problem, @submission), notice: "Submission was created successfully"
    else
      render :new
    end
  end

  private
  def load_contest
    @contest = Contest.find params[:contest_id]
  end

  def load_problem
    @problem = @contest.problems.find params[:problem_id]
  end

  def submission_params
    ## TODO permit upload file or content
    params.require(:submission).permit(:problem_id, :content, :attached_file)
  end

  def check_opening_contest
    ## TODO check opening contest
  end
end
