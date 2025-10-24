class WorkLogTasksController < ApplicationController
  before_action :require_login
  before_action :set_work_log_task

  def start
    if @work_log_task.planned?
      @work_log_task.update!(status: :in_progress)
      redirect_back(fallback_location: root_path, notice: "Task started!")
    else
      redirect_back(fallback_location: root_path, alert: "Task is already in progress or completed.")
    end
  end

  def complete
    if @work_log_task.in_progress?
      @work_log_task.update!(status: :completed)
      @work_log_task.task.increment_usage
      redirect_back(fallback_location: root_path, notice: "Task completed! Great work!")
    else
      redirect_back(fallback_location: root_path, alert: "Task must be in progress to mark as complete.")
    end
  end

  private

  def set_work_log_task
    @work_log_task = WorkLogTask.find(params[:id])

    # Ensure user can only manage their own work log tasks
    unless @work_log_task.work_log.user == current_user
      redirect_back(fallback_location: root_path, alert: "Access denied.")
    end
  end
end