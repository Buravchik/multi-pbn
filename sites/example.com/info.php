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
                <?php
                // Display PHP information
                phpinfo();
                ?>
            </div>
        </main>
        
        <footer>
            <p>&copy; <?php echo date('Y'); ?> <?php echo htmlspecialchars($site_name); ?>. PHP Info Page.</p>
        </footer>
    </div>
</body>
</html>
