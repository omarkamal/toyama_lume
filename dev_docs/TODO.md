# Lume – Immediate Tasks

## Rails App Setup
- [ ] Generate Rails app with `--database=postgresql --skip-javascript` (then add Hotwire)
- [ ] Set up Docker + bin/setup script
- [ ] Create `User` model (with role: employee/admin)

## Core Models & Database
- [ ] Create `WorkLog` model (punch_in/out timestamps, location coords, mood)
- [ ] **Create `Task` model** (title, description, category, priority, user_id, is_global, usage_count)
- [ ] **Create `WorkLogTask` join table** (work_log_id, task_id, duration_minutes, status, notes)
- [ ] Set up model relationships and validations
- [ ] Create database migrations with proper indexes

## Task Management System
- [ ] **Build task creation interface** (for users to create personal tasks)
- [ ] **Build admin task template management** (global task templates)
- [ ] **Implement smart suggestion engine** (frequency, recent, time-based patterns)
- [ ] **Create task selection interface with autocomplete** (mobile-first design)
- [ ] **Add task categories and priority levels** with visual indicators
- [ ] **Implement task usage tracking** for better suggestions

## Enhanced Punch Flow
- [ ] Implement geolocation capture via Stimulus controller on punch views
- [ ] **Redesign punch-in form** with task selection as primary interaction
- [ ] **Redesign punch-out form** with task completion tracking
- [ ] Build punch-in/out Turbo Frames with validation
- [ ] **Add time tracking per task** during the day
- [ ] **Implement quick task status updates** (planned → in_progress → completed)

## Additional Features
- [ ] Create `LeaveRequest` model + basic approval flow (boolean + timestamps)
- [ ] Add static holiday list (YAML → seed data)
- [ ] Build policy hub: `Policy` model with title, body (HTML), and uploaded file
- [ ] Implement mood pulse as enum on `WorkLog` (happy/neutral/sad)

## Admin Dashboard & Analytics
- [ ] Build admin dashboard with Turbo Streams for live-ish updates
- [ ] **Add task analytics views** (time spent per category, completion rates)
- [ ] **Implement task template management** for admins
- [ ] **Add task performance insights** (anonymized team trends)
- [ ] Add search to policy hub and daily logs (pg_search or basic SQL)

## Testing & Deployment
- [ ] Write system tests for punch flow and leave submission
- [ ] **Write tests for task selection and suggestion features**
- [ ] Deploy to staging (e.g., Render or AWS)
