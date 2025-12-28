class LeaveRequestsController < ApplicationController
  before_action :require_login
  before_action :set_leave_request, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_admin!, only: [ :approve, :reject ]

  def index
    @leave_requests = current_user.leave_requests.includes(:approved_by)
      .order(start_date: :desc)

    # Filter by status if provided
    if params[:status].present?
      @leave_requests = @leave_requests.where(status: params[:status])
    end

    # Group by status for easier display
    @pending_requests = @leave_requests.select(&:pending?)
    @approved_requests = @leave_requests.select(&:approved?)
    @rejected_requests = @leave_requests.select(&:rejected?)
  end

  def new
    @leave_request = current_user.leave_requests.build
  end

  def create
    @leave_request = current_user.leave_requests.build(leave_request_params)

    if @leave_request.save
      redirect_to leave_requests_path, notice: "Leave request submitted successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Show is handled by index, but keeping for completeness
  end

  def edit
    # Only allow editing pending requests
    unless @leave_request.pending?
      redirect_to leave_requests_path, alert: "Can only edit pending requests"
    end
  end

  def update
    # Only allow updating pending requests
    unless @leave_request.pending?
      redirect_to leave_requests_path, alert: "Can only edit pending requests"
      return
    end

    if @leave_request.update(leave_request_params)
      redirect_to leave_requests_path, notice: "Leave request updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Only allow deleting pending requests
    unless @leave_request.pending?
      redirect_to leave_requests_path, alert: "Can only delete pending requests"
      return
    end

    @leave_request.destroy
    redirect_to leave_requests_path, notice: "Leave request deleted successfully"
  end

  def approve
    @leave_request = LeaveRequest.find(params[:id])
    @leave_request.approve!(current_user)
    redirect_to admin_dashboard_path, notice: "Leave request approved successfully"
  end

  def reject
    @leave_request = LeaveRequest.find(params[:id])
    @leave_request.reject!(current_user)
    redirect_to admin_dashboard_path, notice: "Leave request rejected successfully"
  end

  private

  def set_leave_request
    if current_user&.admin?
      @leave_request = LeaveRequest.find(params[:id])
    else
      @leave_request = current_user.leave_requests.find(params[:id])
    end
  end

  def leave_request_params
    params.require(:leave_request).permit(:start_date, :end_date, :half_day, :reason)
  end

  def authorize_admin!
    unless current_user.can_approve_leave?
      redirect_to root_path, alert: "Access denied"
    end
  end
end
