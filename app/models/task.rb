class Task < ApplicationRecord
  belongs_to :user
  has_many :work_log_tasks, dependent: :destroy
  has_many :work_logs, through: :work_log_tasks

  enum :priority, { low: "low", medium: "medium", high: "high" }, default: :medium

  validates :title, presence: true
  validates :category, presence: true
  validates :user, presence: true
  validates :priority, presence: true
  validates :usage_count, numericality: { greater_than_or_equal_to: 0 }

  scope :global, -> { where(is_global: true) }
  scope :personal, -> { where(is_global: false) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :popular, -> { where(usage_count: 5..).order(usage_count: :desc) }

  def increment_usage
    increment!(:usage_count)
  end

  def self.suggested_for(user, limit: 10)
    tasks = global.popular
    tasks += user.tasks.order(usage_count: :desc).limit(5)
    tasks.uniq.first(limit)
  end

  def self.search_for(query, user)
    where("title ILIKE ? OR category ILIKE ?", "%#{query}%", "%#{query}%")
      .where(user: user).or(where(is_global: true))
      .order(is_global: :desc, usage_count: :desc)
  end
end
