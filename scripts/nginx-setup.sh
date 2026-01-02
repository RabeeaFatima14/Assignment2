#!/bin/bash
# Enhanced Nginx Load Balancer Setup Script
# This script installs Nginx, generates self-signed SSL certificate, and configures load balancing

set -e  # Exit on any error

# Update system packages
echo "Updating system packages..."
dnf update -y

# Install Nginx and OpenSSL
echo "Installing Nginx and OpenSSL..."
dnf install -y nginx openssl

# Get instance metadata using IMDSv2
echo "Fetching instance metadata..."
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)

# Create SSL directory
echo "Creating SSL directory..."
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
echo "Generating self-signed SSL certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx-selfsigned.key \
    -out /etc/nginx/ssl/nginx-selfsigned.crt \
    -subj "/C=PK/ST=Sindh/L=Karachi/O=CloudComputing/OU=Assignment2/CN=${PUBLIC_IP}"

# Create Nginx configuration
echo "Creating Nginx configuration..."
cat > /etc/nginx/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'upstream: $upstream_addr';

    access_log /var/log/nginx/access.log main;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript 
               application/json application/javascript application/xml+rss;

    # Cache configuration
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m 
                     max_size=100m inactive=60m use_temp_path=off;

    # Upstream backend servers (PLACEHOLDER - UPDATE AFTER DEPLOYMENT)
    upstream backend_servers {
        # Replace with actual private IPs after terraform apply
        server 10.0.10.10:80 max_fails=3 fail_timeout=30s;
        server 10.0.10.20:80 max_fails=3 fail_timeout=30s;
        server 10.0.10.30:80 backup;
    }

    # HTTP Server - Redirect to HTTPS
    server {
        listen 80;
        server_name _;
        return 301 https://$host$request_uri;
    }

    # HTTPS Server - Load Balancer
    server {
        listen 443 ssl http2;
        server_name _;

        # SSL Configuration
        ssl_certificate /etc/nginx/ssl/nginx-selfsigned.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx-selfsigned.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        # Root location - Load balancing with caching
        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # Caching configuration
            proxy_cache my_cache;
            proxy_cache_valid 200 302 10m;
            proxy_cache_valid 404 1m;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            proxy_cache_background_update on;
            proxy_cache_lock on;
            add_header X-Cache-Status $upstream_cache_status;

            # Timeouts
            proxy_connect_timeout 30s;
            proxy_send_timeout 30s;
            proxy_read_timeout 30s;
        }

        # Health check endpoint
        location /nginx-health {
            access_log off;
            return 200 "Nginx Load Balancer is healthy
";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Create cache directory
echo "Creating cache directory..."
mkdir -p /var/cache/nginx
chown -R nginx:nginx /var/cache/nginx

# Set correct permissions
echo "Setting permissions..."
chmod 600 /etc/nginx/ssl/nginx-selfsigned.key
chmod 644 /etc/nginx/ssl/nginx-selfsigned.crt

# Test Nginx configuration
echo "Testing Nginx configuration..."
nginx -t

# Start and enable Nginx service
echo "Starting Nginx service..."
systemctl start nginx
systemctl enable nginx

# Configure firewall
echo "Configuring firewall..."
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# Display final status
echo "======================================"
echo "Nginx Load Balancer setup completed!"
echo "Access your load balancer at:"
echo "  HTTPS: https://${PUBLIC_IP}"
echo "  HTTP: http://${PUBLIC_IP} (redirects to HTTPS)"
echo ""
echo "IMPORTANT: Update backend server IPs in:"
echo "  /etc/nginx/nginx.conf (upstream backend_servers section)"
echo "Then run: sudo systemctl reload nginx"
echo "======================================"

