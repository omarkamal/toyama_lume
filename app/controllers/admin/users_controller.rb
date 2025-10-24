class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: [ :show, :edit, :update ]

  def index
    @users = User.all.order(:name)
  end

  def show
    @work_zones = @user.work_zones
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated successfully."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :remote, :role)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin only."
    end
  end
end
