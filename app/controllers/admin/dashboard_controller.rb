class Admin::DashboardController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @total_users = User.count
    @remote_users = User.where(remote: true).count
    @total_work_zones = WorkZone.count
    @recent_users = User.order(created_at: :desc).limit(5)

    # Leave approval data
    @pending_leave_requests = LeaveRequest.includes(:user).pending.order(:start_date)
    @recent_leave_requests = LeaveRequest.includes(:user, :approved_by).order(created_at: :desc).limit(5)
    @leave_stats = {
      pending: LeaveRequest.pending.count,
      approved_this_month: LeaveRequest.approved.where("approved_at >= ?", Date.current.beginning_of_month).count,
      total_this_year: LeaveRequest.current_year.count
    }
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin only."
    end
  end
end
