# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_28_000001) do
  create_table "leave_requests", force: :cascade do |t|
    t.datetime "approved_at"
    t.integer "approved_by_id"
    t.datetime "created_at", null: false
    t.date "end_date", null: false
    t.boolean "half_day", default: false
    t.text "reason"
    t.date "start_date", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["approved_by_id"], name: "index_leave_requests_on_approved_by_id"
    t.index ["status"], name: "index_leave_requests_on_status"
    t.index ["user_id", "start_date"], name: "index_leave_requests_on_user_id_and_start_date"
    t.index ["user_id", "status"], name: "index_leave_requests_on_user_id_and_status"
    t.index ["user_id"], name: "index_leave_requests_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_global", default: false
    t.string "priority"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "usage_count", default: 0
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.boolean "remote", default: false, null: false
    t.boolean "requires_task_tracking", default: false, null: false
    t.string "role"
    t.datetime "updated_at", null: false
  end

  create_table "work_log_tasks", force: :cascade do |t|
    t.boolean "carry_forward", default: false
    t.datetime "created_at", null: false
    t.integer "duration_minutes"
    t.text "notes"
    t.string "status"
    t.integer "task_id", null: false
    t.datetime "updated_at", null: false
    t.integer "work_log_id", null: false
    t.index ["task_id"], name: "index_work_log_tasks_on_task_id"
    t.index ["work_log_id"], name: "index_work_log_tasks_on_work_log_id"
  end

  create_table "work_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.decimal "location_lat"
    t.decimal "location_lng"
    t.string "mood"
    t.datetime "punch_in"
    t.datetime "punch_out"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_work_logs_on_user_id"
  end

  create_table "work_zones", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.string "name", null: false
    t.integer "radius", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["active"], name: "index_work_zones_on_active"
    t.index ["user_id"], name: "index_work_zones_on_user_id"
  end

  add_foreign_key "leave_requests", "users"
  add_foreign_key "leave_requests", "users", column: "approved_by_id"
  add_foreign_key "tasks", "users"
  add_foreign_key "work_log_tasks", "tasks"
  add_foreign_key "work_log_tasks", "work_logs"
  add_foreign_key "work_logs", "users"
end
