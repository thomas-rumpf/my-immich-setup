# Immich Home Server Setup

This repository contains the configuration and scripts for my [Immich](https://immich.app/) instance. Immich is a high-performance self-hosted photo and video management solution.

## Architecture

The setup runs on Docker Compose and consists of the following services:

- **immich-server**: The main application server (API and Web).
- **immich-machine-learning**: Handles AI tasks like face recognition and CLIP search.
- **redis**: Key-value store for session management and job queues.
- **database**: PostgreSQL 14 with `pgvector` for vector-based search.

## Prerequisites

- **Docker** and **Docker Compose** installed.
- Access to the home network where the media is stored.
- SSH keys configured for syncing and backups.

## Deployment

1. **Clone this repository** to your target server.
2. **Configure Environment Variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your specific paths and passwords
   ```
3. **Set up API Key** (optional, for scripts):
   ```bash
   cp scripts/immich-API-key.txt.example scripts/immich-API-key.txt
   # Add your Immich API key
   ```
4. **Launch the services**:
   ```bash
   docker compose up -d
   ```

## Configuration

- **`.env`**: Contains sensitive variables like database passwords and storage locations (`UPLOAD_LOCATION`, `DB_DATA_LOCATION`).
- **`config/immich-config.json`**: Immich-specific application settings (FFmpeg, Machine Learning, Storage Templates, etc.).
- **External Libraries**: The setup is configured to mount an external photo directory:
  - `/home/USER/photos` on the host is mapped to `/home/USER/photos` in the container.

## Maintenance & Syncing

### Pulling Configuration from Server
If changes are made directly on the live server, sync them back to this repository using:
```bash
./pull-from-server.sh
```
This script uses `rsync` to pull configuration files while excluding large data directories (defined in `exclude.txt`).

### Backup Strategy
Backups are handled by scripts in the `scripts/` directory:

- **`scripts/backup-immich.sh`**: Performs a daily backup of the `media/` directory to a remote server (can be on your home netowrk or elsewhere).
  - Sends a notification via `ntfy.sh/YourAlertChannel` with the count of backed-up images for each user.
- **`scripts/backup-immich-terastation.sh`**: Performs a weekly backup of the `media/` directory to a NAS attached to the local network.
- **Database Backup**: Configured within `immich-config.json` to run daily at 02:00 via cron.

## Monitoring
Daily backup status is pushed to `ntfy.sh/YourAlertChannel`. Check the `log/` directory for detailed `rsync` logs.
