class Admin::WorkZonesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: [ :new, :create ]
  before_action :set_work_zone, only: [ :edit, :update, :destroy ]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @work_zones = @user.work_zones
    else
      @work_zones = WorkZone.all.includes(:user).order(:name)
    end
  end

  def new
    @work_zone = @user.work_zones.new
  end

  def create
    @work_zone = @user.work_zones.new(work_zone_params)
    if @work_zone.save
      redirect_to admin_user_path(@user), notice: "Work zone created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @work_zone.update(work_zone_params)
      redirect_to admin_user_path(@work_zone.user), notice: "Work zone updated successfully."
    else
      render :edit
    end
  end

  def destroy
    user = @work_zone.user
    @work_zone.destroy
    redirect_to admin_user_path(user), notice: "Work zone deleted successfully."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_work_zone
    @work_zone = WorkZone.find(params[:id])
  end

  def work_zone_params
    params.require(:work_zone).permit(:name, :latitude, :longitude, :radius, :active)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin only."
    end
  end
end
