class User < ApplicationRecord
  enum :role, { employee: "employee", admin: "admin" }, default: :employee

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  has_secure_password

  has_many :work_logs, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :work_log_tasks, through: :work_logs
end
