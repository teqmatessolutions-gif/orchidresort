# Orchid Production Deployment Instructions

## Changes Committed
All changes have been committed and pushed to the repository:
- Dark logo cards in dashboard and login page
- Transparent headers and footers in userend
- Loader improvements (green circle, transparent background, larger logo)
- Food items API fixes (POST/PUT routes with trailing slash support)
- Logo visibility improvements

## Deployment Steps

### Option 1: Using the Deployment Script (Recommended)

1. SSH into the production server:
   ```bash
   ssh user@teqmates.com
   ```

2. Navigate to the production directory and run the deployment script:
   ```bash
   cd /var/www/resort/orchid_production
   chmod +x deploy_orchid_production.sh
   ./deploy_orchid_production.sh
   ```

### Option 2: Manual Deployment

1. **Pull latest code:**
   ```bash
   cd /var/www/resort/orchid_production
   git pull origin main
   ```

2. **Build Userend:**
   ```bash
   cd /var/www/resort/orchid_production/userend/userend
   npm install --legacy-peer-deps
   npm run build
   ```

3. **Build Dashboard:**
   ```bash
   cd /var/www/resort/orchid_production/dasboard
   npm install --legacy-peer-deps
   npm run build
   ```

4. **Restart Backend Service:**
   ```bash
   sudo systemctl restart orchid.service
   sudo systemctl status orchid.service
   ```

5. **Reload Nginx (if needed):**
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

## Verification

After deployment, verify the following:

1. **Userend:** https://teqmates.com/orchid
   - Check that header and footer are transparent
   - Verify logo card is dark
   - Test loader shows green circle with transparent background

2. **Dashboard:** https://teqmates.com/orchidadmin
   - Check login page has dark logo card
   - Verify dashboard logo card is dark
   - Test food items creation/editing works

3. **API:** https://teqmates.com/orchidapi/api
   - Verify food items POST/PUT endpoints work correctly

## Important Notes

- ✅ This deployment ONLY affects Orchid (userend and dashboard)
- ✅ Does NOT touch Pomma Holidays or Pomma Admin
- ✅ Backend runs on port 8011 (orchid.service)
- ✅ Frontend builds are served via Nginx

## Rollback (if needed)

If you need to rollback:
```bash
cd /var/www/resort/orchid_production
git log --oneline -10  # Find the previous commit
git checkout <previous-commit-hash>
# Then rebuild and restart services
```
