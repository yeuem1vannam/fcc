class Api::V1::ProblemsController < Api::BaseController
  before_filter :load_user, only: [:show]
  before_filter :load_problem, only: [:show]

  def show
    @res = @user.submissions.of_problem(@problem).accepted.first
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
  end

  def load_problem
    @problem = Problem.find_by id: params[:id]
  end
end
