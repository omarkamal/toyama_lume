# Lume

**Mission**: A simple, privacy-respecting internal app to streamline daily workflows, time tracking, and well-being for Toyama’s 40-person team.

**Tech Stack**: Ruby on Rails 8+, Hotwire (Turbo + Stimulus), PostgreSQL, Docker

**Local Setup**:
```bash
git clone <repo>
cd lume
bin/setup          # installs gems, creates DB, loads sample data
bin/dev            # starts server + JS build watcher
# App runs at http://localhost:3000
