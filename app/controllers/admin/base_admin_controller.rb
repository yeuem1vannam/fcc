class Admin::BaseAdminController < ApplicationController
  layout "admin_layout"
  before_filter :authenticate_admin!

  def after_sign_in_path_for(resource)
    admin_admins_path
  end
end
