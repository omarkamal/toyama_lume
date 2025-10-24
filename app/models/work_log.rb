class WorkLog < ApplicationRecord
  belongs_to :user
  has_many :work_log_tasks, dependent: :destroy
  has_many :tasks, through: :work_log_tasks

  enum :mood, { happy: "happy", neutral: "neutral", sad: "sad" }, default: :neutral

  validates :user, presence: true
  validates :punch_in, presence: true
  validate :punch_out_after_punch_in

  def duration_hours
    return 0 unless punch_out
    ((punch_out - punch_in) / 1.hour).round(2)
  end

  def total_task_duration
    work_log_tasks.sum(:duration_minutes)
  end

  private

  def punch_out_after_punch_in
    return unless punch_in && punch_out
    errors.add(:punch_out, "must be after punch in") if punch_out <= punch_in
  end
end
