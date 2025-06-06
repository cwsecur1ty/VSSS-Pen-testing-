#!/bin/bash

# Simple Web Server Setup Script for Penetration Testing Practice
# Creates a basic web application for scanning and testing
# Author: cwsecur1ty

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Setting up Basic Web Server for Pen-Testing Practice${NC}"
echo "This will install Apache and create a simple web application"
echo ""

# Update system
echo -e "${YELLOW}[1/4] Updating system packages...${NC}"
sudo apt update -y

# Install Apache and PHP
echo -e "${YELLOW}[2/4] Installing Apache and PHP...${NC}"
sudo apt install -y apache2 php php-mysql libapache2-mod-php

# Start and enable Apache
echo -e "${YELLOW}[3/4] Starting Apache service...${NC}"
sudo systemctl start apache2
sudo systemctl enable apache2

# Create web app
echo -e "${YELLOW}[4/4] Creating basic web application...${NC}"

# Remove default Apache page (index.html)   
sudo rm -f /var/www/html/index.html

# Create index.php
sudo tee /var/www/html/index.php > /dev/null << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pen-Testing Lab - Web Application</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; color: #333; margin-bottom: 30px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .nav { background: #007cba; padding: 15px; margin: -30px -30px 30px -30px; border-radius: 8px 8px 0 0; }
        .nav a { color: white; text-decoration: none; margin: 0 15px; }
        .nav a:hover { text-decoration: underline; }
        .info-box { background: #e7f3ff; padding: 15px; border-left: 4px solid #007cba; margin: 15px 0; }
        .form-group { margin: 15px 0; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #007cba; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn:hover { background: #005a87; }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav">
            <a href="index.php">Home</a>
            <a href="login.php">Login</a>
            <a href="contact.php">Contact</a>
            <a href="about.php">About</a>
            <a href="admin.php">Admin</a>
        </div>
        
        <div class="header">
            <h1>Welcome to Pen-Testing Lab</h1>
            <p>Basic Web Application for Security Testing Practice</p>
        </div>
        
        <div class="section">
            <h3>Application Information</h3>
            <div class="info-box">
                <p><strong>Server:</strong> <?php echo $_SERVER['SERVER_SOFTWARE'] ?? 'Apache'; ?></p>
                <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
                <p><strong>Server IP:</strong> <?php echo $_SERVER['SERVER_ADDR'] ?? 'localhost'; ?></p>
                <p><strong>Current Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
            </div>
        </div>
        
        <div class="section">
            <h3>Quick Search</h3>
            <form method="GET" action="search.php">
                <div class="form-group">
                    <label for="query">Search Term:</label>
                    <input type="text" id="query" name="q" placeholder="Enter search term">
                </div>
                <button type="submit" class="btn">Search</button>
            </form>
        </div>
        
        <div class="section">
            <h3>Available Pages</h3>
            <ul>
                <li><a href="login.php">User Login</a></li>
                <li><a href="contact.php">Contact Form</a></li>
                <li><a href="about.php">About Us</a></li>
                <li><a href="admin.php">Admin Panel</a></li>
                <li><a href="api.php">API Endpoint</a></li>
                <li><a href="files/">File Directory</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF

# Create login.php
sudo tee /var/www/html/login.php > /dev/null << 'EOF'
<?php
session_start();
$message = '';

if ($_POST['username'] && $_POST['password']) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // Simple authentication check
    if ($username === 'admin' && $password === 'password') {
        $_SESSION['logged_in'] = true;
        $_SESSION['username'] = $username;
        $message = '<div style="color: green;">Login successful! Welcome admin.</div>';
    } else {
        $message = '<div style="color: red;">Invalid credentials.</div>';
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Pen-Testing Lab</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>User Login</h2>
        <?php echo $message; ?>
        <form method="POST">
            <div class="form-group">
                <label>Username:</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">Login</button>
        </form>
        <p><a href="index.php">Back to Home</a></p>
    </div>
</body>
</html>
EOF

# Create contact.php
sudo tee /var/www/html/contact.php > /dev/null << 'EOF'
<?php
$message = '';
if ($_POST['name'] && $_POST['email'] && $_POST['message']) {
    $name = htmlspecialchars($_POST['name']);
    $email = htmlspecialchars($_POST['email']);
    $msg = htmlspecialchars($_POST['message']);
    $message = '<div style="color: green;">Thank you for your message, ' . $name . '!</div>';
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Contact - Pen-Testing Lab</title>
</head>
<body>
    <div class="container">
        <h2>Contact Us</h2>
        <?php echo $message; ?>
        <form method="POST">
            <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name" required>
            </div>
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Message:</label>
                <textarea name="message" rows="5" required></textarea>
            </div>
            <button type="submit" class="btn">Send Message</button>
        </form>
        <p><a href="index.php">Back to Home</a></p>
    </div>
</body>
</html>
EOF

# Create about.php
sudo tee /var/www/html/about.php > /dev/null << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>About - Pen-Testing Lab</title>
</head>
<body>
    <div class="container">
        <h2>About This Application</h2>
        <p>This is a basic web application created for penetration testing practice and security scanning.</p>
        
        <h3>Application Features:</h3>
        <ul>
            <li>User authentication system</li>
            <li>Contact form</li>
            <li>Search functionality</li>
            <li>File management</li>
            <li>Admin panel</li>
            <li>API endpoints</li>
        </ul>
        
        <h3>Technologies Used:</h3>
        <ul>
            <li>Apache Web Server</li>
            <li>PHP <?php echo phpversion(); ?></li>
            <li>HTML/CSS</li>
            <li>JavaScript</li>
        </ul>
        
        <p><a href="index.php">Back to Home</a></p>
    </div>
</body>
</html>
EOF

# Create admin.php
sudo tee /var/www/html/admin.php > /dev/null << 'EOF'
<?php
session_start();
?>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - Pen-Testing Lab</title>
</head>
<body>
    <div class="container">
        <h2>Admin Panel</h2>
        
        <?php if (isset($_SESSION['logged_in']) && $_SESSION['logged_in']): ?>
            <div style="color: green;">Welcome, <?php echo $_SESSION['username']; ?>!</div>
            <h3>Admin Functions:</h3>
            <ul>
                <li><a href="admin.php?action=users">View Users</a></li>
                <li><a href="admin.php?action=logs">View Logs</a></li>
                <li><a href="admin.php?action=config">System Config</a></li>
            </ul>
            
            <?php
            if (isset($_GET['action'])) {
                switch ($_GET['action']) {
                    case 'users':
                        echo '<h4>User List:</h4>';
                        echo '<p>admin - Administrator</p>';
                        echo '<p>user1 - Standard User</p>';
                        echo '<p>guest - Guest Account</p>';
                        break;
                    case 'logs':
                        echo '<h4>System Logs:</h4>';
                        echo '<p>2024-01-01 10:00:00 - User login: admin</p>';
                        echo '<p>2024-01-01 09:30:00 - Page accessed: /admin.php</p>';
                        break;
                    case 'config':
                        echo '<h4>System Configuration:</h4>';
                        echo '<p>Debug Mode: Enabled</p>';
                        echo '<p>Log Level: INFO</p>';
                        break;
                }
            }
            ?>
            
        <?php else: ?>
            <div style="color: red;">Access denied. Please <a href="login.php">login</a> first.</div>
        <?php endif; ?>
        
        <p><a href="index.php">Back to Home</a></p>
    </div>
</body>
</html>
EOF

# Create search.php
sudo tee /var/www/html/search.php > /dev/null << 'EOF'
<?php
$query = $_GET['q'] ?? '';
$results = [];

if ($query) {
    // Simple search simulation
    $sample_data = [
        'documentation' => 'System Documentation',
        'users' => 'User Management',
        'admin' => 'Administration Panel',
        'config' => 'Configuration Files',
        'logs' => 'System Logs'
    ];
    
    foreach ($sample_data as $key => $value) {
        if (stripos($key, $query) !== false || stripos($value, $query) !== false) {
            $results[] = $value;
        }
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Search Results - Pen-Testing Lab</title>
</head>
<body>
    <div class="container">
        <h2>Search Results</h2>
        
        <?php if ($query): ?>
            <p>Search query: <strong><?php echo htmlspecialchars($query); ?></strong></p>
            
            <?php if (!empty($results)): ?>
                <h3>Results found:</h3>
                <ul>
                    <?php foreach ($results as $result): ?>
                        <li><?php echo htmlspecialchars($result); ?></li>
                    <?php endforeach; ?>
                </ul>
            <?php else: ?>
                <p>No results found for your search.</p>
            <?php endif; ?>
        <?php else: ?>
            <p>Please enter a search term.</p>
        <?php endif; ?>
        
        <p><a href="index.php">Back to Home</a></p>
    </div>
</body>
</html>
EOF

# Create api.php
sudo tee /var/www/html/api.php > /dev/null << 'EOF'
<?php
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];
$endpoint = $_GET['endpoint'] ?? 'info';

switch ($endpoint) {
    case 'info':
        $response = [
            'status' => 'success',
            'server' => $_SERVER['SERVER_SOFTWARE'] ?? 'Apache',
            'php_version' => phpversion(),
            'timestamp' => date('c')
        ];
        break;
        
    case 'users':
        $response = [
            'status' => 'success',
            'users' => [
                ['id' => 1, 'name' => 'admin', 'role' => 'administrator'],
                ['id' => 2, 'name' => 'user1', 'role' => 'user'],
                ['id' => 3, 'name' => 'guest', 'role' => 'guest']
            ]
        ];
        break;
        
    default:
        $response = [
            'status' => 'error',
            'message' => 'Unknown endpoint'
        ];
        break;
}

echo json_encode($response, JSON_PRETTY_PRINT);
?>
EOF

# Create files directory with sample files
sudo mkdir -p /var/www/html/files
sudo tee /var/www/html/files/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>File Directory</title>
</head>
<body>
    <h2>File Directory</h2>
    <ul>
        <li><a href="readme.txt">readme.txt</a></li>
        <li><a href="config.txt">config.txt</a></li>
        <li><a href="data.json">data.json</a></li>
    </ul>
    <p><a href="../index.php">Back to Home</a></p>
</body>
</html>
EOF

sudo tee /var/www/html/files/readme.txt > /dev/null << 'EOF'
Pen-Testing Lab Application
===========================

This is a basic web application for security testing practice.

Features:
- User authentication
- Search functionality
- Contact forms
- Admin panel
- API endpoints

For testing purposes only.
EOF

sudo tee /var/www/html/files/config.txt > /dev/null << 'EOF'
# Application Configuration
app_name=PenTestLab
version=1.0
debug_mode=true
log_level=info
EOF

sudo tee /var/www/html/files/data.json > /dev/null << 'EOF'
{
  "application": {
    "name": "Pen-Testing Lab",
    "version": "1.0",
    "features": [
      "authentication",
      "search",
      "contact_form",
      "admin_panel",
      "api"
    ]
  },
  "users": [
    {"username": "admin", "role": "administrator"},
    {"username": "user1", "role": "user"}
  ]
}
EOF

# Set permissions and get ip
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
SERVER_IP=$(hostname -I | awk '{print $1}')
# nice output
echo ""
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo "🌐 Your web application is now running at:"
echo "   http://localhost"
echo "   http://$SERVER_IP"
echo ""
echo "📋 Available endpoints for testing:"
echo "   • Main site: http://$SERVER_IP/"
echo "   • Login: http://$SERVER_IP/login.php"
echo "   • Admin: http://$SERVER_IP/admin.php"
echo "   • API: http://$SERVER_IP/api.php?endpoint=info"
echo "   • Files: http://$SERVER_IP/files/"
echo ""
echo "🔑 Test credentials:"
echo "   Username: admin"
echo "   Password: password"
echo ""
echo "🛠️ To stop Apache: sudo systemctl stop apache2"
echo "🔄 To restart Apache: sudo systemctl restart apache2"
echo ""
echo "Ready for penetration testing and vulnerability scanning!"