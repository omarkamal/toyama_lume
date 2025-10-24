# Toyama Lume - Kamal Deployment Guide

This application is configured for deployment using **Kamal 2.8.1** with **Rails 8.1.0**.

## Prerequisites

Before deploying, ensure you have:

1. **A production server** with:
   - Ubuntu 22.04+ (or similar Linux distribution)
   - Docker installed
   - SSH access configured
   - At least 1GB RAM (2GB+ recommended)

2. **A container registry** account (choose one):
   - Docker Hub (hub.docker.com)
   - GitHub Container Registry (ghcr.io)
   - DigitalOcean Container Registry
   - AWS ECR

3. **Local requirements**:
   - Docker Desktop running
   - SSH key added to your server
   - Kamal 2.8.1 installed (`gem install kamal`)

## Step 1: Configure Your Server

Update `config/deploy.yml` with your production server IP:

```yaml
servers:
  web:
    - YOUR_SERVER_IP  # Replace with actual IP (e.g., 134.209.123.45)
```

## Step 2: Choose and Configure Container Registry

### Option A: Docker Hub

1. Create account at hub.docker.com
2. Create a new repository: `your-username/toyama_lume`
3. Generate an access token: Account Settings → Security → Access Tokens

Update `config/deploy.yml`:

```yaml
registry:
  server: hub.docker.com
  username: your-dockerhub-username
  password:
    - KAMAL_REGISTRY_PASSWORD
```

Update `.kamal/secrets`:

```bash
export KAMAL_REGISTRY_PASSWORD="your-access-token"
```

### Option B: GitHub Container Registry (ghcr.io)

1. Generate a Personal Access Token (Settings → Developer settings → Personal access tokens)
   - Select scopes: `write:packages`, `read:packages`, `delete:packages`

Update `config/deploy.yml`:

```yaml
registry:
  server: ghcr.io
  username: omarkamal
  password:
    - KAMAL_REGISTRY_PASSWORD
```

Update `.kamal/secrets`:

```bash
export KAMAL_REGISTRY_PASSWORD="your-github-token"
```

Update `config/deploy.yml` image name:

```yaml
image: omarkamal/toyama_lume
```

## Step 3: Prepare Your Server

SSH into your server and install Docker (if not already installed):

```bash
# SSH into your server
ssh root@YOUR_SERVER_IP

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Start Docker service
systemctl start docker
systemctl enable docker

# Verify installation
docker --version
```

## Step 4: Configure Environment Variables (Optional)

If you need additional environment variables, update `config/deploy.yml`:

```yaml
env:
  secret:
    - RAILS_MASTER_KEY
    # Add more secrets if needed:
    # - DATABASE_URL
    # - SECRET_KEY_BASE
  clear:
    SOLID_QUEUE_IN_PUMA: true
    # Add non-secret env vars here
```

## Step 5: Deploy!

### First-time Setup

```bash
# From your local machine, in the project root:

# Setup Kamal on the server (installs Docker if needed)
bin/kamal setup

# This will:
# - Install required dependencies on the server
# - Build your Docker image
# - Push it to the registry
# - Deploy the application
# - Start all services
```

### Subsequent Deploys

```bash
# Deploy updates
bin/kamal deploy

# This does a zero-downtime deployment
```

## Common Kamal Commands

```bash
# View application logs
bin/kamal app logs -f

# Access Rails console on production
bin/kamal console

# Access server shell
bin/kamal shell

# Access database console
bin/kamal dbc

# Restart the application
bin/kamal app restart

# Stop the application
bin/kamal app stop

# View running containers
bin/kamal app details

# Run database migrations
bin/kamal app exec 'bin/rails db:migrate'

# Rollback to previous version
bin/kamal rollback

# Remove the application from servers
bin/kamal remove
```

## Database Configuration

This application uses SQLite with persistent volumes:

```yaml
volumes:
  - "toyama_lume_storage:/rails/storage"
```

The database and uploaded files are stored in this Docker volume and persist across deployments.

### For PostgreSQL/MySQL (Advanced)

If you want to use an external database:

1. Uncomment and configure the `accessories` section in `config/deploy.yml`
2. Update `config/database.yml` for production
3. Add database credentials to `.kamal/secrets`

## SSL/HTTPS Configuration

To enable HTTPS with automatic SSL certificates:

1. Point your domain to your server's IP
2. Update `config/deploy.yml`:

```yaml
proxy:
  ssl: true
  host: yourdomain.com
```

Kamal will automatically provision Let's Encrypt SSL certificates.

## Troubleshooting

### View all containers on server

```bash
bin/kamal app details
```

### Check if app is running

```bash
bin/kamal app logs --tail 50
```

### Container won't start

```bash
# SSH into server
ssh root@YOUR_SERVER_IP

# Check Docker containers
docker ps -a

# View specific container logs
docker logs toyama_lume-web-latest
```

### Registry authentication issues

```bash
# Test registry login manually
docker login hub.docker.com -u your-username -p your-token
```

### Permission denied errors

Make sure your SSH key is added to the server:

```bash
ssh-copy-id root@YOUR_SERVER_IP
```

## Monitoring

After deployment, your app will be available at:

- **HTTP**: `http://YOUR_SERVER_IP`
- **HTTPS** (if SSL configured): `https://yourdomain.com`

## Security Checklist

- [ ] Use strong passwords for registry access
- [ ] Keep `.kamal/secrets` out of version control (already in .gitignore)
- [ ] Configure firewall on your server (allow ports 80, 443, 22)
- [ ] Regularly update server packages
- [ ] Use SSH keys instead of password authentication
- [ ] Consider using a password manager for secrets (1Password, etc.)

## Cost Optimization

- Start with a small server (1GB RAM ~$6/month on DigitalOcean)
- Scale up as needed
- Use managed databases for critical data
- Consider CDN for assets (Cloudflare is free)

## Next Steps

1. Configure your domain DNS
2. Set up monitoring (Honeybadger, Sentry, AppSignal)
3. Configure backups for your database
4. Set up CI/CD (GitHub Actions) for automated deployments

---

**Need help?** Check the [Kamal documentation](https://kamal-deploy.org/) or Rails 8.1 deployment guides.
