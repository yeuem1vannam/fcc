class Admin::AdminsController < Admin::BaseAdminController
  before_filter :load_object, only: [:show, :edit, :update, :destroy]
  before_filter :build_object, only: [:new, :create]

  def index
    @q = Admin.search params[:q]
    @admins = @q.result.page params[:page]
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @admin.save
      redirect_to admin_admin_path(@admin),
        notice: {:".created" => {name: @admin.name}}
    else
      render :new
    end
  end

  def update
    if @admin.update_attributes params[:admin]
      sign_in current_admin, bypass: true
      redirect_to admin_admin_path(@admin),
        notice: {:".updated" => {name: @admin.name}}
    else
      render :edit
    end
  end

  def destroy
    @admin.destroy
    redirect_to admin_admins_url,
      notice: {:".destroyed" => {name: @admin.name}}
  end

  private
  def load_object
    @admin = Admin.find params[:id]
  end

  def build_object
    @admin = Admin.new params[:admin]
  end
end
