
---

### 📄 `SPEC.md`

```md
# Lume – Feature Specification

## ✅ Core Features (MVP)
- Employees can punch in/out only when within approved geofenced locations (via browser geolocation).
- **Smart task selection**: On punch-in, users select from auto-suggested tasks (personal + global templates) with minimal typing.
- **Task-based tracking**: Users can add time estimates and track progress per task throughout the day.
- **Auto-suggestion engine**: Suggests tasks based on frequency, recent activity, time patterns, and team trends (anonymized).
- Submit and view leave requests (pending/approved/rejected).
- View company + national holidays in a shared calendar.
- Optional one-tap mood check (😊 / 😐 / 😞) at punch-in/out—no explanation required.
- Read-only, searchable policy hub (HTML/PDF uploads).
- **Admin task management**: Create/edit global task templates, view task analytics and time tracking.
- Admin dashboard: view team attendance, leave status, aggregate mood trends, task completion metrics, and searchable daily logs.

## ⚠️ Constraints
- Must work on mobile browsers (no native app).
- Location validation uses browser geolocation only—no background tracking.
- Mood data is anonymized in dashboards; never linked to individual performance.
- **Task-first approach**: Primary interaction through task selection, with optional free-text fallback.
- **Smart defaults**: Minimize required input while maintaining data quality.
- **Privacy-focused**: Personal task data visible only to user; aggregated trends anonymized.

## 🚫 Non-Goals (v1)
- Asset tracking
- Gamification or badges
- Real-time notifications
- Third-party calendar or Slack integrations
