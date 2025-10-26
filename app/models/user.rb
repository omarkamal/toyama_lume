class User < ApplicationRecord
  enum :role, { employee: "employee", admin: "admin" }, default: :employee

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  has_secure_password

  has_many :work_logs, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :work_log_tasks, through: :work_logs
  has_many :work_zones, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :approved_leave_requests, class_name: 'LeaveRequest', foreign_key: :approved_by_id

  # Remote workers can punch in from anywhere
  # Regular employees must be within their assigned work zones
  def remote_worker?
    remote
  end

  # Get pending tasks from previous sessions that were marked to carry forward
  def pending_tasks
    work_log_tasks.pending.includes(:task, work_log: :user).order("work_logs.punch_in DESC")
  end

  # Get unique pending task IDs for punch-in suggestions
  def pending_task_ids
    pending_tasks.pluck(:task_id).uniq
  end

  # Leave management methods
  def leave_on_date?(date)
    leave_requests.approved.where("start_date <= ? AND end_date >= ?", date, date).exists?
  end

  def current_leave
    leave_requests.approved.where("start_date <= ? AND end_date >= ?", Date.current, Date.current).first
  end

  def upcoming_leave
    leave_requests.approved.upcoming.order(:start_date).first
  end

  def leave_taken_this_year
    leave_requests.approved.current_year.sum(&:business_days)
  end

  def can_approve_leave?
    admin?
  end

  # Work week configuration (can be extended per user if needed)
  def work_week_days
    # Default: Monday to Friday (1-5, where 0 = Sunday, 6 = Saturday)
    # Can be configured to Monday to Saturday in config/initializers/leave_settings.rb
    [1, 2, 3, 4, 5] # Monday-Friday
  end

  def weekend_day?(date)
    !work_week_days.include?(date.wday)
  end
end
