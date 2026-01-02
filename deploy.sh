#!/bin/bash
# =============================
# AUTO DEPLOY SCRIPT (Node/React + PM2)
# =============================

set -e  # exit on error

LOG_FILE="/var/www/2zuagain-web/logs/deploy.log"
PROJECT_DIR="/var/www/2zuagain-web"
APP_NAME="2zuagain-app"

# Create log folder if not exist
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"
chmod 664 "$LOG_FILE"
chown www-data:www-data "$LOG_FILE"

echo "===== AUTO DEPLOY START =====" >> "$LOG_FILE"
date >> "$LOG_FILE"

# Switch to project dir
cd "$PROJECT_DIR"

# Git safe directory
sudo -u www-data git config --global --add safe.directory "$PROJECT_DIR" || true

# Reset local changes to avoid merge conflicts
sudo -u www-data git reset --hard origin/main >> "$LOG_FILE" 2>&1

# Pull latest code
echo "Pulling latest code..." >> "$LOG_FILE"
sudo -u www-data git pull origin main >> "$LOG_FILE" 2>&1

# Install Node dependencies
echo "Installing Node dependencies..." >> "$LOG_FILE"
sudo -u www-data npm install >> "$LOG_FILE" 2>&1

# Build React frontend if exists
if [ -f package.json ] && grep -q "react-scripts" package.json; then
    echo "Building React frontend..." >> "$LOG_FILE"
    sudo -u www-data npm run build >> "$LOG_FILE" 2>&1
fi

# Restart Node app via PM2
echo "Restarting Node app via PM2..." >> "$LOG_FILE"
if pm2 describe "$APP_NAME" > /dev/null 2>&1; then
    sudo -u www-data pm2 reload "$APP_NAME" >> "$LOG_FILE" 2>&1
else
    sudo -u www-data pm2 start server.js --name "$APP_NAME" >> "$LOG_FILE" 2>&1
fi

# Save PM2 process list
sudo -u www-data pm2 save >> "$LOG_FILE" 2>&1

echo "===== AUTO DEPLOY END =====" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
