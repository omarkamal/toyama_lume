# Lume – Database Design (MVP)

All tables use Rails conventions (`created_at`, `updated_at`, `id` as primary key).

---

## `users`
Employees and admins.
- `id` (bigint, PK)
- `email` (string, unique)
- `name` (string)
- `role` (string) → "employee" or "admin"
- `location_enabled` (boolean, default: true) → whether geofencing applies

> One user has many work logs and leave requests.

---

## `tasks`
Task templates and user-specific tasks for auto-suggestion.
- `id` (bigint, PK)
- `title` (string) → "Fix login bug", "Design dashboard", etc.
- `description` (text, optional) → detailed task description
- `category` (string, optional) → "development", "design", "meeting", "admin"
- `priority` (string, default: "medium") → "high", "medium", "low"
- `estimated_hours` (decimal, optional)
- `user_id` (bigint, FK → users.id, nullable) → null for global tasks
- `is_global` (boolean, default: false) → company-wide tasks
- `status` (string, default: "active") → "active", "archived"
- `usage_count` (integer, default: 0) → tracks popularity for smart suggestions

> Can belong to a user (personal tasks) or be global (team templates).

---

## `work_log_tasks`
Join table connecting daily work logs with specific tasks.
- `id` (bigint, PK)
- `work_log_id` (bigint, FK → work_logs.id)
- `task_id` (bigint, FK → tasks.id)
- `duration_minutes` (integer, optional) → time spent on this specific task
- `status` (string) → "planned", "in_progress", "completed"
- `notes` (text, optional) → task-specific notes

> Connects work logs to tasks, enabling detailed time tracking.

---

## `work_logs`
Daily punch-in/out + optional free-text notes + mood.
- `id` (bigint, PK)
- `user_id` (bigint, FK → users.id)
- `punch_in_at` (datetime)
- `punch_out_at` (datetime, nullable)
- `planned_work` (text, optional) → "Today I'll work on…" (fallback)
- `completed_work` (text, optional) → "Today I completed…" (fallback)
- `mood` (string, nullable) → "happy", "neutral", or "sad"
- `location_lat` (decimal, nullable)
- `location_lng` (decimal, nullable)

> Belongs to one user. One log per workday. Primary task tracking via work_log_tasks.

---

## `leave_requests`
Time-off requests (full/half day, sick, etc.).
- `id` (bigint, PK)
- `user_id` (bigint, FK → users.id)
- `start_date` (date)
- `end_date` (date)
- `half_day` (boolean, default: false)
- `reason` (text, optional)
- `status` (string) → "pending", "approved", "rejected"
- `approved_by_id` (bigint, FK → users.id, nullable)

> Belongs to a user; optionally approved by another user (admin).

---

## `holidays`
Company and national holidays.
- `id` (bigint, PK)
- `name` (string) → e.g., "Diwali", "National Holiday"
- `date` (date, unique)
- `company_only` (boolean, default: false) → true = Toyama-specific

> Static data (seeded). No relationships.

---

## `policies`
Company policy documents.
- `id` (bigint, PK)
- `title` (string)
- `body` (text, optional) → rendered HTML
- `file_url` (string, optional) → link to uploaded PDF
- `version` (string, default: "1.0")
- `published_at` (datetime)

> No user ownership. Read-only for all employees.

---

## Relationships Summary
- `User` → has many → `WorkLog`, `LeaveRequest`, `Task` (personal), `WorkLogTask` (through work logs)
- `User` (admin) → can approve → `LeaveRequest` (via `approved_by_id`)
- `User` (admin) → can manage → global `Task` templates
- `WorkLog` → has many → `WorkLogTask`
- `Task` → has many → `WorkLogTask`
- `WorkLogTask` → belongs to → `WorkLog`, `Task`

> Enhanced task tracking enables detailed time analysis while maintaining simplicity.
