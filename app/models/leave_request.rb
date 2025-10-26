class LeaveRequest < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true
  validate :end_date_after_start_date
  validate :no_date_conflicts, on: :create
  validate :reasonable_date_range

  enum :status, { pending: 'pending', approved: 'approved', rejected: 'rejected' }, default: :pending

  scope :for_user, ->(user) { where(user: user) }
  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :rejected, -> { where(status: :rejected) }
  scope :current_year, -> { where("start_date >= ? AND start_date <= ?", Date.current.beginning_of_year, Date.current.end_of_year) }
  scope :upcoming, -> { where("start_date >= ?", Date.current) }
  scope :past, -> { where("end_date < ?", Date.current) }

  def duration_days
    return 0.5 if half_day?
    return 1 if start_date == end_date

    (end_date - start_date + 1).to_i
  end

  def business_days
    return 0.5 if half_day?
    return 1 if start_date == end_date

    business_days = 0
    current_date = start_date
    holidays = load_holidays

    while current_date <= end_date
      unless weekend_day?(current_date) || holidays.include?(current_date)
        business_days += 1
      end
      current_date += 1.day
    end

    business_days
  end

  def includes_date?(date)
    (start_date..end_date).include?(date)
  end

  def holidays_during_leave
    return [] if half_day?

    holidays = load_holidays
    holidays.select { |holiday| (start_date..end_date).include?(holiday) }
  end

  def weekends_during_leave
    return [] if half_day?

    weekends = []
    current_date = start_date

    while current_date <= end_date
      if weekend_day?(current_date)
        weekends << current_date
      end
      current_date += 1.day
    end

    weekends
  end

  def approve!(admin_user)
    update!(status: :approved, approved_by: admin_user)
  end

  def reject!(admin_user)
    update!(status: :rejected, approved_by: admin_user)
  end

  # Add approved_at timestamp when status changes to approved
  after_update :set_approved_at, if: :saved_change_to_approved_status?

  private

  def set_approved_at
    update_column(:approved_at, Time.current) if approved?
  end

  def saved_change_to_approved_status?
    saved_change_to_status? && approved?
  end

  def load_holidays
    yaml_path = Rails.root.join('config', 'holidays.yml')
    return [] unless File.exist?(yaml_path)

    yaml_data = YAML.load_file(yaml_path)
    holiday_dates = []

    # Add company holidays
    if yaml_data['company_holidays']
      yaml_data['company_holidays'].each do |holiday|
        holiday_dates << Date.parse(holiday['date'])
      end
    end

    # Add national holidays
    if yaml_data['national_holidays_japan']
      yaml_data['national_holidays_japan'].each do |holiday|
        holiday_dates << Date.parse(holiday['date'])
      end
    end

    holiday_dates
  end

  def weekend_day?(date)
    user.weekend_day?(date)
  end

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "must be after start date") if end_date < start_date
  end

  def no_date_conflicts
    return unless user && start_date && end_date

    conflicts = user.leave_requests.approved.where(
      "(start_date <= ? AND end_date >= ?)",
      end_date, start_date
    )

    errors.add(:base, "You already have approved leave during this period") if conflicts.exists?
  end

  def reasonable_date_range
    return unless start_date && end_date

    max_days = 30 # Maximum 30 days per leave request
    if (end_date - start_date + 1).to_i > max_days && !half_day?
      errors.add(:base, "Leave requests cannot exceed #{max_days} days")
    end

    if start_date < Date.current - 7.days
      errors.add(:start_date, "cannot be more than 7 days in the past")
    end

    if start_date > Date.current + 1.year
      errors.add(:start_date, "cannot be more than 1 year in advance")
    end
  end
end
