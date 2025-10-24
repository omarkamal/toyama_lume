# Lume

**Mission**: A simple, privacy-respecting internal app to streamline daily workflows, time tracking, and well-being for Toyama's 40-person team.

**Tech Stack**: Ruby on Rails 8.1, Hotwire (Turbo + Stimulus), SQLite, Kamal Deployment

**Local Setup**:
```bash
git clone <repo>
cd lume
bin/setup          # installs gems, creates DB, loads sample data
bin/dev            # starts server + JS build watcher
# App runs at http://localhost:3000
```

**Production Deployment**:
```bash
# See DEPLOYMENT.md for full deployment guide
bin/kamal setup    # First-time setup
bin/kamal deploy   # Deploy updates
```

**Quick Links**:
- [Full Deployment Guide](./DEPLOYMENT.md) - Complete Kamal deployment instructions
- [Development Docs](./dev_docs/) - Feature specs, UX guidelines, and brand identity
