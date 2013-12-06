class User::BaseUserController < ApplicationController
  layout "user_layout"
  before_filter :check_maintenance

  private
  def check_maintenance
    render 'public/maintenance.html' if Settings.is_maintenance && !current_user.try(:is_reviewer?)
  end
end
