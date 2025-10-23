# Lume – Key Decisions

- 2025-10-23: Chose **Rails 7 + Hotwire** over React → full-stack simplicity, rapid iteration, minimal JS for internal tool.
- 2025-10-23: Using **browser geolocation via Stimulus** → no native app needed; sufficient for office/client-site validation.
- 2025-10-23: Mood stored as enum on `WorkLog` but **excluded from user-identifiable reports** → protects privacy while enabling wellness insights.
- 2025-10-23: Daily logs **required with 10-char min** → lightweight accountability without bureaucracy.
- 2025-10-23: Policies stored as **HTML + optional PDF upload** → easier to update than static files; searchable.
