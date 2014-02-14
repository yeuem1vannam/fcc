class User::UsersController < User::BaseUserController
  before_filter :check_login, only: [:update]

  def update
    current_user.update_attributes(user_params)
    respond_to do |format|
      format.html {redirect_to user_contests_path}
      format.json {head :no_content}
    end
  end

  private
  def check_login
    redirect_to user_contests_path unless current_user
  end

  def user_params
    params.require(:user).permit(:locale)
  end
end
