#!/bin/bash
# Enhanced Apache Web Server Setup Script
# This script installs and configures Apache with a custom page showing instance metadata

set -e  # Exit on any error

# Update system packages
echo "Updating system packages..."
dnf update -y

# Install Apache HTTP Server
echo "Installing Apache HTTP Server..."
dnf install -y httpd

# Get instance metadata using IMDSv2
echo "Fetching instance metadata..."
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)
INSTANCE_TYPE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null)
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null)
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone 2>/dev/null)
HOSTNAME=$(hostname)

# Create custom HTML page with instance information
echo "Creating custom web page..."
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backend Server - ${HOSTNAME}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 600px;
            width: 100%;
        }
        h1 {
            color: #667eea;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        .info-grid {
            display: grid;
            gap: 15px;
        }
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .info-label {
            font-weight: bold;
            color: #495057;
            margin-bottom: 5px;
        }
        .info-value {
            color: #212529;
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }
        .timestamp {
            text-align: center;
            margin-top: 30px;
            color: #6c757d;
            font-size: 0.9em;
        }
        .badge {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Backend Server</h1>
        <div class="badge">Apache HTTP Server</div>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Hostname</div>
                <div class="info-value">${HOSTNAME}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Instance ID</div>
                <div class="info-value">${INSTANCE_ID}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Instance Type</div>
                <div class="info-value">${INSTANCE_TYPE}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Private IP</div>
                <div class="info-value">${PRIVATE_IP}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Public IP</div>
                <div class="info-value">${PUBLIC_IP}</div>
            </div>
            <div class="info-item">
                <div class="info-label">Availability Zone</div>
                <div class="info-value">${AVAILABILITY_ZONE}</div>
            </div>
        </div>
        
        <div class="timestamp">
            Page generated at: $(date '+%Y-%m-%d %H:%M:%S %Z')
        </div>
    </div>
</body>
</html>
EOF

# Configure Apache to listen on port 80
echo "Configuring Apache..."
sed -i 's/Listen 80/Listen 0.0.0.0:80/g' /etc/httpd/conf/httpd.conf

# Start and enable Apache service
echo "Starting Apache service..."
systemctl start httpd
systemctl enable httpd

# Configure firewall
echo "Configuring firewall..."
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Display status
echo "======================================"
echo "Apache installation completed!"
echo "Server is running on:"
echo "  Private IP: ${PRIVATE_IP}"
echo "  Public IP: ${PUBLIC_IP}"
echo "======================================"

