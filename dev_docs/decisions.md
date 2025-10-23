# Lume – Key Decisions

- 2025-10-23: Chose **Rails 7 + Hotwire** over React → full-stack simplicity, rapid iteration, minimal JS for internal tool.
- 2025-10-23: Using **browser geolocation via Stimulus** → no native app needed; sufficient for office/client-site validation.
- 2025-10-23: Mood stored as enum on `WorkLog` but **excluded from user-identifiable reports** → protects privacy while enabling wellness insights.
- 2025-10-23: Daily logs **required with 10-char min** → lightweight accountability without bureaucracy.
- 2025-10-23: Policies stored as **HTML + optional PDF upload** → easier to update than static files; searchable.
- 2025-10-23: **Task-based workflow** over free-text entries → provides structure, better data quality, and enables smart auto-suggestions.
- 2025-10-23: **Hybrid task approach** (personal + global templates) → gives flexibility while maintaining consistency across team.
- 2025-10-23: **Smart suggestion engine** prioritizes UX → minimal typing, learns from patterns, reduces cognitive load for daily tracking.
- 2025-10-23: **Mobile-first task selection** with autocomplete → ensures "absolute pleasure" interaction on phones/tablets.
