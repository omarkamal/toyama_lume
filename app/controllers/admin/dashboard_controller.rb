class Admin::DashboardController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @total_users = User.count
    @remote_users = User.where(remote: true).count
    @total_work_zones = WorkZone.count
    @recent_users = User.order(created_at: :desc).limit(5)
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin only."
    end
  end
end
