#!/bin/bash

# -------------------------------
# AUTO DEPLOY SCRIPT
# สำหรับ Node.js + React + PM2
# -------------------------------

echo "===== AUTO DEPLOY START ====="
date

# ไปยัง directory ของ project
cd /var/www/2zuagain-web || exit 1

# -------------------------------
# Step 1: Reset local changes
# -------------------------------
echo "Resetting any local changes..."
git fetch --all
git reset --hard origin/main
git clean -fd

# -------------------------------
# Step 2: Pull latest code
# -------------------------------
echo "Pulling latest code from GitHub..."
git pull origin main

# -------------------------------
# Step 3: Setup Node backend
# -------------------------------
echo "Installing/updating Node.js backend dependencies..."
npm install

# -------------------------------
# Step 4: Build frontend React app
# -------------------------------
if [ -d "frontend" ]; then
  echo "Building React frontend..."
  cd frontend || exit 1
  npm install
  npm run build
  cd ..
fi

# -------------------------------
# Step 5: Restart backend with PM2
# -------------------------------
echo "Restarting backend with PM2..."
pm2 restart 2zuagain || pm2 start server.js --name 2zuagain

echo "===== AUTO DEPLOY END ====="
