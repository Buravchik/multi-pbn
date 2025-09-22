<?php
// Tomoffinlandwines.com - Main entry point
// This file handles SPA routing for non-existing URLs

// Get the requested path
$requestUri = $_SERVER['REQUEST_URI'];
$path = parse_url($requestUri, PHP_URL_PATH);

// If this is the root path, show a welcome message
if ($path === '/' || $path === '/index.php') {
    echo "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Tomoffinlandwines.com</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { color: #333; }
        .info { background: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class='container'>
        <h1>Welcome to Tomoffinlandwines.com</h1>
        <div class='info'>
            <h2>Site Information</h2>
            <p><strong>Requested Path:</strong> " . htmlspecialchars($path) . "</p>
            <p><strong>Server Time:</strong> " . date('Y-m-d H:i:s') . "</p>
            <p><strong>PHP Version:</strong> " . PHP_VERSION . "</p>
        </div>
        <div class='info'>
            <h2>Available Files</h2>
            <ul>
                <li><a href='/archivarix.cms.php'>Archivarix CMS</a></li>
                <li><a href='/test.php'>Test PHP</a></li>
            </ul>
        </div>
    </div>
</body>
</html>";
} else {
    // For other paths, show a 404 with helpful information
    http_response_code(404);
    echo "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Page Not Found - Tomoffinlandwines.com</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { color: #d32f2f; }
        .info { background: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class='container'>
        <h1>404 - Page Not Found</h1>
        <div class='info'>
            <p><strong>Requested Path:</strong> " . htmlspecialchars($path) . "</p>
            <p><strong>Server Time:</strong> " . date('Y-m-d H:i:s') . "</p>
            <p>This page was handled by the SPA routing system.</p>
        </div>
        <div class='info'>
            <h2>Available Pages</h2>
            <ul>
                <li><a href='/'>Home</a></li>
                <li><a href='/archivarix.cms.php'>Archivarix CMS</a></li>
                <li><a href='/test.php'>Test PHP</a></li>
            </ul>
        </div>
    </div>
</body>
</html>";
}
?>
