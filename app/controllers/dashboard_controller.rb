class DashboardController < ApplicationController
  before_action :require_login

  def index
    @current_work_log = current_user.work_logs.where(punch_out: nil).first
    @today_work_logs = current_user.work_logs.where(punch_in: Date.current.all_day)
    @week_work_logs = current_user.work_logs.where(punch_in: Date.current.beginning_of_week..Date.current.end_of_week)
    @recent_work_logs = current_user.work_logs.order(punch_in: :desc).limit(10)

    # Only fetch task-related data if user needs task tracking
    if current_user.needs_task_tracking?
      @suggested_tasks = Task.suggested_for(current_user)
      @my_tasks = current_user.tasks.personal.limit(10)

      # Calculate active tasks (in-progress work log tasks)
      if @current_work_log
        @active_tasks = @current_work_log.work_log_tasks.where(status: :in_progress)
      else
        @active_tasks = []
      end

      # Get pending tasks count
      @pending_tasks_count = current_user.pending_tasks.count
    else
      # Set empty defaults for users who don't track tasks
      @suggested_tasks = []
      @my_tasks = []
      @active_tasks = []
      @pending_tasks_count = 0
    end

    # Leave statistics
    @pending_leave_requests = current_user.leave_requests.pending
    @upcoming_leave = current_user.upcoming_leave
    @current_leave = current_user.current_leave
    @leave_taken_this_year = current_user.leave_taken_this_year

    # Check if user is on leave today
    @on_leave_today = current_user.leave_on_date?(Date.current)
  end
end
