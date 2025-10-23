
---

### 📄 `SPEC.md`

```md
# Lume – Feature Specification

## ✅ Core Features (MVP)
- Employees can punch in/out only when within approved geofenced locations (via browser geolocation).
- On punch-in: user must enter 1–2 sentences for “Today’s plan”.
- On punch-out: user must enter 1–2 sentences for “Today’s completion”.
- Submit and view leave requests (pending/approved/rejected).
- View company + national holidays in a shared calendar.
- Optional one-tap mood check (😊 / 😐 / 😞) at punch-in/out—no explanation required.
- Read-only, searchable policy hub (HTML/PDF uploads).
- Admin dashboard: view team attendance, leave status, aggregate mood trends, and searchable daily logs.

## ⚠️ Constraints
- Must work on mobile browsers (no native app).
- Location validation uses browser geolocation only—no background tracking.
- Mood data is anonymized in dashboards; never linked to individual performance.
- All text inputs require ≥10 characters to prevent empty logs.

## 🚫 Non-Goals (v1)
- Asset tracking
- Gamification or badges
- Real-time notifications
- Third-party calendar or Slack integrations
