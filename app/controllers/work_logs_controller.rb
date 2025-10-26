class WorkLogsController < ApplicationController
  before_action :require_login

  def index
    @pagy, @work_logs = pagy(current_user.work_logs.order(punch_in: :desc))
  end

  def show
    @work_log = current_user.work_logs.find(params[:id])
  end

  def punch_in
    # Check if user is on approved leave today
    if current_user.leave_on_date?(Date.current)
      current_leave = current_user.current_leave
      redirect_to root_path, alert: "You're on approved leave today (#{current_leave.start_date.strftime('%B %d')} - #{current_leave.end_date.strftime('%B %d')}). You cannot punch in while on leave."
      return
    end

    # Check if user already has an active work log
    active_work_log = current_user.work_logs.where(punch_out: nil).first

    if active_work_log
      redirect_to root_path, alert: "You're already punched in!"
      return
    end

    if request.post?
      # Handle form submission
      @work_log = current_user.work_logs.new(
        punch_in: Time.current,
        mood: params.dig(:work_log, :mood) || :neutral,
        location_lat: params[:location_lat],
        location_lng: params[:location_lng]
      )

      # Validate location is present
      if params[:location_lat].blank? || params[:location_lng].blank?
        @work_log.errors.add(:base, "Location is required to punch in")
        render turbo_stream: turbo_stream.replace("punch_in_modal", partial: "work_logs/punch_in_modal")
        return
      end

      # Validate geofencing
      unless within_work_zone?(params[:location_lat], params[:location_lng])
        @work_log.errors.add(:base, "You are outside of approved work zones. Please punch in from an authorized location.")
        render turbo_stream: turbo_stream.replace("punch_in_modal", partial: "work_logs/punch_in_modal")
        return
      end

      if @work_log.save
        # Only add tasks if user needs task tracking
        if current_user.needs_task_tracking?
          # Add selected tasks
          if params[:work_log][:task_ids].present?
            params[:work_log][:task_ids].each do |task_id|
              next if task_id.blank?
              task = Task.find(task_id)
              @work_log.work_log_tasks.create!(task: task, status: :planned)

              # Clear carry_forward flag from previous pending tasks when re-added
              current_user.work_log_tasks.pending.where(task_id: task_id).update_all(carry_forward: false)
            end
          end

          # Add custom task if provided
          if params[:custom_task].present?
            custom_task = current_user.tasks.create!(
              title: params[:custom_task],
              category: "Custom",
              priority: :medium,
              is_global: false
            )
            @work_log.work_log_tasks.create!(task: custom_task, status: :planned)
          end
        end

        redirect_to root_path, notice: "Successfully punched in!"
      else
        render turbo_stream: turbo_stream.replace("punch_in_modal", partial: "work_logs/punch_in_modal")
      end
    else
      # Show modal
      @work_log = current_user.work_logs.new

      # Only fetch tasks if user needs task tracking
      if current_user.needs_task_tracking?
        @suggested_tasks = Task.suggested_for(current_user, limit: 4)

        # Get pending tasks from previous sessions
        @pending_tasks = current_user.pending_tasks.map(&:task).uniq

        # Fallback: if no suggestions, get some popular global tasks
        if @suggested_tasks.empty?
          @suggested_tasks = Task.global.popular.limit(4)
        end
      end

      # Check if we should request mood (random weekly check)
      @should_request_mood = should_request_mood?(current_user)

      Rails.logger.info "Debug: Current user: #{current_user&.email}"
      Rails.logger.info "Debug: Needs task tracking: #{current_user.needs_task_tracking?}"
      Rails.logger.info "Debug: Suggested tasks count: #{@suggested_tasks&.count || 0}"
      Rails.logger.info "Debug: Should request mood: #{@should_request_mood}"
      render turbo_stream: turbo_stream.update("punch_in_modal", partial: "work_logs/punch_in_modal")
    end
  end

  def punch_out
    @work_log = current_user.work_logs.where(punch_out: nil).first

    unless @work_log
      redirect_to root_path, alert: "You're not currently punched in!"
      return
    end

    # Always show modal first (GET request)
    # Check if we should request mood (random weekly check)
    @should_request_mood = should_request_mood?(current_user)
    Rails.logger.info "Debug: Punch out - Should request mood: #{@should_request_mood}"
    Rails.logger.info "Debug: User needs task tracking: #{current_user.needs_task_tracking?}"
    render turbo_stream: turbo_stream.update("punch_out_modal", partial: "work_logs/punch_out_modal")
  end

  def add_task
    @work_log = current_user.work_logs.find(params[:id])
    @task = Task.find(params[:task_id])

    # Check if task is already added to this work log
    if @work_log.tasks.include?(@task)
      redirect_to root_path, alert: "Task is already added to this session."
      return
    end

    # Create work_log_task association
    work_log_task = @work_log.work_log_tasks.create!(
      task: @task,
      status: :planned
    )

    if work_log_task.persisted?
      redirect_to root_path, notice: "Successfully added '#{@task.title}' to your session!"
    else
      redirect_to root_path, alert: "Failed to add task to session."
    end
  end

  def new_task
    @work_log = current_user.work_logs.find(params[:id])
    @suggested_tasks = Task.suggested_for(current_user, limit: 5)

    render turbo_stream: turbo_stream.update("task_modal", partial: "work_logs/task_modal")
  end

  def complete_punch_out
    @work_log = current_user.work_logs.find(params[:id])

    if @work_log.punch_out.present?
      redirect_to root_path, alert: "You've already punched out!"
      return
    end

    # Validate location is present
    if params[:location_lat].blank? || params[:location_lng].blank?
      @work_log.errors.add(:base, "Location is required to punch out")
      render turbo_stream: turbo_stream.replace("punch_out_modal", partial: "work_logs/punch_out_modal")
      return
    end

    # Validate geofencing
    unless within_work_zone?(params[:location_lat], params[:location_lng])
      @work_log.errors.add(:base, "You are outside of approved work zones. Please punch out from an authorized location.")
      render turbo_stream: turbo_stream.replace("punch_out_modal", partial: "work_logs/punch_out_modal")
      return
    end

    # Handle form submission
    @work_log.update!(punch_out: Time.current, location_lat: params[:location_lat], location_lng: params[:location_lng], mood: params.dig(:work_log, :mood) || :neutral)

    # Only handle task updates if user needs task tracking
    if current_user.needs_task_tracking?
      # Update task completion status
      if params[:work_log_task_ids].present?
        params[:work_log_task_ids].each do |task_id|
          work_log_task = @work_log.work_log_tasks.find(task_id)
          work_log_task.update!(status: :completed, duration_minutes: params[:durations][task_id])
          work_log_task.task.increment_usage
        end
      end

      # Mark tasks for carry forward (uncompleted tasks to add to pending)
      if params[:carry_forward_task_ids].present?
        params[:carry_forward_task_ids].each do |task_id|
          work_log_task = @work_log.work_log_tasks.find(task_id)
          work_log_task.update!(carry_forward: true)
        end
      end

      # Add additional tasks
      if params[:additional_tasks].present?
        params[:additional_tasks].each do |task_title|
          next if task_title.blank?

          new_task = current_user.tasks.create!(
            title: task_title,
            category: "Custom",
            priority: :medium,
            is_global: false
          )

          @work_log.work_log_tasks.create!(
            task: new_task,
            status: :completed,
            duration_minutes: 30 # default duration
          )

          new_task.increment_usage
        end
      end
    end

    redirect_to root_path, notice: "Successfully punched out! Great work today!"
  end

  private

  def within_work_zone?(lat, lng)
    # Remote workers can punch in from anywhere
    return true if current_user.remote_worker?

    # Get user-specific work zones and global work zones
    user_zones = WorkZone.for_user(current_user)
    global_zones = WorkZone.global

    all_zones = user_zones + global_zones

    # Check if the location is within any of the zones
    all_zones.any? { |zone| zone.contains?(lat, lng) }
  end
end
