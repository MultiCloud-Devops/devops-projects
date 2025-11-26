#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e

# === Variables ===
S3_BUCKET="s3://cfsp-be-under-maintain-bkt/site-under-maintenance.html"
HTML_FILE="/usr/share/nginx/html/index.html"
REGION="us-east-1"

echo "=== Updating system and installing dependencies ==="
sudo yum update -y
sudo yum install -y nginx awscli

echo "=== Enabling and starting NGINX service ==="
sudo systemctl enable nginx
sudo systemctl start nginx

# Verify NGINX started
if ! systemctl is-active --quiet nginx; then
  echo "❌ Failed to start nginx. Check systemctl logs."
  exit 1
fi

echo "=== Downloading maintenance page from S3 ==="
sudo aws s3 cp "$S3_BUCKET" "$HTML_FILE" --region "$REGION"

# Ensure permissions are correct
sudo chown nginx:nginx "$HTML_FILE"
sudo chmod 644 "$HTML_FILE"

echo "=== Restarting NGINX to apply changes ==="
sudo systemctl restart nginx

# Validate port 80 is listening
if sudo ss -tuln | grep -q ':80'; then
  echo "✅ NGINX is active and serving on port 80."
else
  echo "⚠️ Port 80 not open — verify security group or NGINX config."
fi

echo "=== Maintenance page deployed successfully! ==="
