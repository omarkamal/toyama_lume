class DashboardController < ApplicationController
  before_action :require_login

  def index
    @current_work_log = current_user.work_logs.where(punch_out: nil).first
    @today_work_logs = current_user.work_logs.where(punch_in: Date.current.all_day)
    @week_work_logs = current_user.work_logs.where(punch_in: Date.current.beginning_of_week..Date.current.end_of_week)
    @suggested_tasks = Task.suggested_for(current_user)
    @my_tasks = current_user.tasks.personal.limit(10)
    @recent_work_logs = current_user.work_logs.order(punch_in: :desc).limit(10)

    # Calculate active tasks (in-progress work log tasks)
    if @current_work_log
      @active_tasks = @current_work_log.work_log_tasks.where(status: :in_progress)
    else
      @active_tasks = []
    end
  end
end
