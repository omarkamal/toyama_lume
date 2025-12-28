class Admin::LeaveRequestsController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @leave_requests = LeaveRequest.includes(:user, :approved_by).order(created_at: :desc)

    # Filter by status if provided
    if params[:status].present?
      @leave_requests = @leave_requests.where(status: params[:status])
    end

    # Filter by user if provided
    if params[:user_id].present?
      @leave_requests = @leave_requests.where(user_id: params[:user_id])
    end

    # Filter by date range if provided
    if params[:start_date].present?
      @leave_requests = @leave_requests.where("start_date >= ?", params[:start_date])
    end

    if params[:end_date].present?
      @leave_requests = @leave_requests.where("end_date <= ?", params[:end_date])
    end

    # Group by status for easy display
    @pending_requests = @leave_requests.select(&:pending?)
    @approved_requests = @leave_requests.select(&:approved?)
    @rejected_requests = @leave_requests.select(&:rejected?)

    # Statistics
    @stats = {
      total: @leave_requests.count,
      pending: @leave_requests.select(&:pending?).count,
      approved_this_month: @leave_requests.select(&:approved?).select { |lr| lr.approved_at && lr.approved_at >= Date.current.beginning_of_month }.count,
      total_this_year: @leave_requests.select { |lr| lr.start_date.year == Date.current.year }.count
    }

    # Users for filtering
    @users = User.includes(:leave_requests).order(:name)
  end

  def show
    @leave_request = LeaveRequest.includes(:user, :approved_by).find(params[:id])
  end

  def approve
    @leave_request = LeaveRequest.find(params[:id])

    if @leave_request.approved?
      redirect_to admin_leave_requests_path, alert: "Leave request is already approved"
      return
    end

    @leave_request.approve!(current_user)
    redirect_to admin_leave_requests_path, notice: "Leave request approved successfully"
  end

  def reject
    @leave_request = LeaveRequest.find(params[:id])

    if @leave_request.rejected?
      redirect_to admin_leave_requests_path, alert: "Leave request is already rejected"
      return
    end

    @leave_request.reject!(current_user)
    redirect_to admin_leave_requests_path, notice: "Leave request rejected successfully"
  end

  def bulk_approve
    leave_request_ids = params[:leave_request_ids] || []

    if leave_request_ids.empty?
      redirect_to admin_leave_requests_path, alert: "No leave requests selected"
      return
    end

    approved_count = 0
    LeaveRequest.where(id: leave_request_ids, status: :pending).find_each do |leave_request|
      leave_request.approve!(current_user)
      approved_count += 1
    end

    redirect_to admin_leave_requests_path, notice: "#{approved_count} leave request(s) approved successfully"
  end

  def bulk_reject
    leave_request_ids = params[:leave_request_ids] || []

    if leave_request_ids.empty?
      redirect_to admin_leave_requests_path, alert: "No leave requests selected"
      return
    end

    rejected_count = 0
    LeaveRequest.where(id: leave_request_ids, status: :pending).find_each do |leave_request|
      leave_request.reject!(current_user)
      rejected_count += 1
    end

    redirect_to admin_leave_requests_path, notice: "#{rejected_count} leave request(s) rejected successfully"
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin only."
    end
  end
end
