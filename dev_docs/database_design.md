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

## `work_logs`
Daily punch-in/out + intent/reflection + mood.
- `id` (bigint, PK)
- `user_id` (bigint, FK → users.id)
- `punch_in_at` (datetime)
- `punch_out_at` (datetime, nullable)
- `planned_work` (text) → "Today I’ll work on…"
- `completed_work` (text, nullable) → "Today I completed…"
- `mood` (string, nullable) → "happy", "neutral", or "sad"
- `location_lat` (decimal, nullable)
- `location_lng` (decimal, nullable)

> Belongs to one user. One log per workday.

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
- `User` → has many → `WorkLog`, `LeaveRequest`
- `User` (admin) → can approve → `LeaveRequest` (via `approved_by_id`)
- `WorkLog`, `LeaveRequest`, `Holiday`, `Policy` → standalone or user-scoped, no complex joins

> No asset tracking, teams, or departments in MVP.
