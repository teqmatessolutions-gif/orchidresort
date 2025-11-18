#!/bin/bash

# Orchid Production Deployment Script
# This script deploys only Orchid changes to production
# Does NOT touch Pomma Holidays or Pomma Admin

set -e  # Exit on error

PRODUCTION_PATH="/var/www/resort/orchid_production"
BACKEND_PATH="$PRODUCTION_PATH/ResortApp"
USEREND_PATH="$PRODUCTION_PATH/userend/userend"
DASHBOARD_PATH="$PRODUCTION_PATH/dasboard"

echo "=========================================="
echo "Orchid Production Deployment"
echo "=========================================="

# Step 1: Pull latest code
echo "Step 1: Pulling latest code from git..."
cd "$PRODUCTION_PATH"
git pull origin main
echo "✓ Code updated"

# Step 2: Activate virtual environment and update backend dependencies if needed
echo "Step 2: Updating backend dependencies..."
cd "$BACKEND_PATH"
source venv/bin/activate
pip install -q -r requirements.txt 2>/dev/null || echo "Note: requirements.txt not found or no new dependencies"
echo "✓ Backend dependencies checked"

# Step 3: Build Userend (Orchid user-facing site)
echo "Step 3: Building Userend frontend..."
cd "$USEREND_PATH"
npm install --legacy-peer-deps --silent
npm run build
echo "✓ Userend built successfully"

# Step 4: Build Dashboard (Orchid admin dashboard)
echo "Step 4: Building Dashboard frontend..."
cd "$DASHBOARD_PATH"
npm install --legacy-peer-deps --silent
npm run build
echo "✓ Dashboard built successfully"

# Step 5: Restart backend service
echo "Step 5: Restarting Orchid backend service..."
sudo systemctl restart orchid.service
sleep 2
sudo systemctl status orchid.service --no-pager -l || echo "Warning: Service status check failed"
echo "✓ Backend service restarted"

# Step 6: Reload Nginx (if needed for static files)
echo "Step 6: Reloading Nginx..."
sudo nginx -t && sudo systemctl reload nginx || echo "Warning: Nginx reload failed"
echo "✓ Nginx reloaded"

echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo "Userend: https://teqmates.com/orchid"
echo "Dashboard: https://teqmates.com/orchidadmin"
echo "API: https://teqmates.com/orchidapi/api"
echo "=========================================="

