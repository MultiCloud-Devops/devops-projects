#!/bin/bash
# Enable full debugging (prints every command)
set -x

# Log everything into userdata.log
exec > >(tee -a /var/log/userdata.log) 2>&1

echo "===== Starting User Data Execution ====="

# Update packages
dnf update -y

# Install SSM Agent
dnf install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install NGINX
dnf install -y nginx
systemctl enable nginx
systemctl start nginx

echo "===== User Data Execution Completed ====="
