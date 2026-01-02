#!/bin/bash

# Update packages
sudo apt-get update

# Install Apache2
sudo apt-get install -y apache2

# Create custom health check endpoint
sudo mkdir -p /var/www/html/health

# Create health check PHP script
sudo tee /var/www/html/health/check.php > /dev/null << 'EOF'
<?php
header('Content-Type: application/json');

$health_status = array(
    'status' => 'healthy',
    'server' => gethostname(),
    'timestamp' => date('Y-m-d H:i:s'),
    'uptime' => shell_exec('uptime -p'),
    'load_average' => sys_getloadavg(),
    'disk_usage' => disk_free_space("/") / disk_total_space("/") * 100,
    'memory_usage' => round((1 - memory_get_usage(true) / 1024 / 1024 / 1024) * 100, 2)
);

echo json_encode($health_status, JSON_PRETTY_PRINT);
?>
EOF

# Install PHP
sudo apt-get install -y php libapache2-mod-php

# Create simple HTML page
sudo tee /var/www/html/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Backend Server</title>
    <style>
        body { font-family: Arial; text-align: center; margin-top: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .container { background: rgba(255,255,255,0.1); padding: 30px; border-radius: 10px; display: inline-block; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Backend Server Response</h1>
        <p>Hostname: <?php echo gethostname(); ?></p>
        <p>Server IP: <?php echo $_SERVER['SERVER_ADDR']; ?></p>
        <p>Request Time: <?php echo date('Y-m-d H:i:s'); ?></p>
    </div>
</body>
</html>
EOF

# Rename to PHP to execute PHP code
sudo mv /var/www/html/index.html /var/www/html/index.php

# Restart Apache
sudo systemctl restart apache2
sudo systemctl enable apache2

