# Lume – Immediate Tasks

- [ ] Generate Rails app with `--database=postgresql --skip-javascript` (then add Hotwire)
- [ ] Set up Docker + bin/setup script
- [ ] Create `User` model (with role: employee/admin)
- [ ] Add `WorkLog` model (intent, reflection, punch_in/out timestamps, location coords)
- [ ] Implement geolocation capture via Stimulus controller on punch views
- [ ] Build punch-in/out Turbo Frames with validation
- [ ] Create `LeaveRequest` model + basic approval flow (boolean + timestamps)
- [ ] Add static holiday list (YAML → seed data)
- [ ] Build policy hub: `Policy` model with title, body (HTML), and uploaded file
- [ ] Implement mood pulse as enum on `WorkLog` (happy/neutral/sad)
- [ ] Build admin dashboard with Turbo Streams for live-ish updates
- [ ] Add search to policy hub and daily logs (pg_search or basic SQL)
- [ ] Write system tests for punch flow and leave submission
- [ ] Deploy to staging (e.g., Render or AWS)
