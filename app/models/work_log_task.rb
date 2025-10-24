class WorkLogTask < ApplicationRecord
  belongs_to :work_log
  belongs_to :task

  enum :status, { planned: "planned", in_progress: "in_progress", completed: "completed", paused: "paused" }, default: :planned

  validates :work_log, presence: true
  validates :task, presence: true
  validates :status, presence: true
  validates :duration_minutes, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :pending, -> { where(carry_forward: true, status: [ :planned, :in_progress ]) }

  def completed?
    status == "completed"
  end

  def in_progress?
    status == "in_progress"
  end

  def mark_as_completed!
    update!(status: :completed)
    task.increment_usage
  end
end
