class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :complete ]

  def index
    @pagy, @tasks = pagy(current_user.tasks.order(created_at: :desc))
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully deleted."
  end

  def suggestions
    @suggested_tasks = Task.suggested_for(current_user)
    respond_to do |format|
      format.json { render json: @suggested_tasks.as_json(only: [ :id, :title, :category, :priority ]) }
    end
  end

  def search
    query = params[:q]
    if query.present?
      @tasks = Task.search_for(query, current_user).limit(10)
    else
      @tasks = []
    end
  end

  def my_tasks
    @pagy, @my_tasks = pagy(current_user.tasks.personal.order(created_at: :desc))
  end

  def complete
    @work_log_task = @task.work_log_tasks.find_or_initialize_by(
      work_log: current_user.work_logs.where(punch_out: nil).first
    )

    if @work_log_task.persisted?
      @work_log_task.mark_as_completed!
      redirect_back(fallback_location: dashboard_path, notice: "Task marked as completed!")
    else
      redirect_back(fallback_location: dashboard_path, alert: "No active work session found.")
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :category, :priority, :is_global)
  end
end
