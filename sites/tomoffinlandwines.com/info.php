<?php
// PHP Info page - useful for debugging and development
$site_name = basename(__DIR__);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Info - <?php echo htmlspecialchars($site_name); ?></title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .phpinfo {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
            overflow-x: auto;
        }
        .phpinfo table {
            width: 100%;
            border-collapse: collapse;
        }
        .phpinfo th, .phpinfo td {
            border: 1px solid #dee2e6;
            padding: 8px 12px;
            text-align: left;
        }
        .phpinfo th {
            background-color: #e9ecef;
            font-weight: bold;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-link:hover {
            background-color: #0056b3;
        }
        .security-notice {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .security-notice h3 {
            color: #856404;
            margin-top: 0;
        }
        .security-notice p {
            color: #856404;
            margin-bottom: 10px;
        }
        .security-notice ul {
            color: #856404;
            margin-left: 20px;
        }
        .basic-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
        }
        .basic-info h3 {
            margin-top: 0;
            color: #495057;
        }
        .basic-info table {
            width: 100%;
            border-collapse: collapse;
        }
        .basic-info th, .basic-info td {
            border: 1px solid #dee2e6;
            padding: 8px 12px;
            text-align: left;
        }
        .basic-info th {
            background-color: #e9ecef;
            font-weight: bold;
            width: 30%;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>PHP Information</h1>
            <p>Detailed PHP configuration for <?php echo htmlspecialchars($site_name); ?></p>
        </header>
        
        <main>
            <a href="index.php" class="back-link">← Back to Home</a>
            
            <div class="phpinfo">
                <div class="security-notice">
                    <h3>🔒 Security Notice</h3>
                    <p><strong>PHP Info page is disabled for security reasons.</strong></p>
                    <p>This page would normally display detailed PHP configuration information, but it has been disabled in production to prevent information disclosure.</p>
                    <p>If you need to access PHP information for debugging purposes, please:</p>
                    <ul>
                        <li>Access this page from localhost only</li>
                        <li>Use a development environment</li>
                        <li>Contact your system administrator</li>
                    </ul>
                </div>
                
                <div class="basic-info">
                    <h3>Basic PHP Information</h3>
                    <table>
                        <tr>
                            <th>PHP Version</th>
                            <td><?php echo htmlspecialchars(phpversion()); ?></td>
                        </tr>
                        <tr>
                            <th>Server Software</th>
                            <td><?php echo htmlspecialchars($_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'); ?></td>
                        </tr>
                        <tr>
                            <th>Current Time</th>
                            <td><?php echo htmlspecialchars(date('Y-m-d H:i:s')); ?></td>
                        </tr>
                    </table>
                </div>
            </div>
        </main>
        
        <footer>
            <p>&copy; <?php echo date('Y'); ?> <?php echo htmlspecialchars($site_name); ?>. PHP Info Page.</p>
        </footer>
    </div>
</body>
</html>
