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

    # Parse Google Maps URL if provided
    if params[:google_maps_url].present?
      coords = GoogleMapsParser.parse(params[:google_maps_url])
      if coords
        @work_zone.latitude = coords[:latitude]
        @work_zone.longitude = coords[:longitude]
      else
        @work_zone.errors.add(:base, "Could not parse coordinates from Google Maps URL")
        render :new and return
      end
    end

    if @work_zone.save
      redirect_to admin_user_path(@user), notice: "Work zone created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    @work_zone.assign_attributes(work_zone_params)

    # Parse Google Maps URL if provided
    if params[:google_maps_url].present?
      coords = GoogleMapsParser.parse(params[:google_maps_url])
      if coords
        @work_zone.latitude = coords[:latitude]
        @work_zone.longitude = coords[:longitude]
      else
        @work_zone.errors.add(:base, "Could not parse coordinates from Google Maps URL")
        render :edit and return
      end
    end

    if @work_zone.save
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
