<?php
// PHP example page
$site_name = basename(__DIR__);
$current_time = date('Y-m-d H:i:s');
$php_version = phpversion();
$server_info = $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($site_name); ?> - PHP Site</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Welcome to <?php echo htmlspecialchars($site_name); ?></h1>
            <p>This is a PHP-powered website!</p>
        </header>
        
        <main>
            <section class="info">
                <h2>Server Information</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Current Time:</strong>
                        <span><?php echo htmlspecialchars($current_time); ?></span>
                    </div>
                    <div class="info-item">
                        <strong>PHP Version:</strong>
                        <span><?php echo htmlspecialchars($php_version); ?></span>
                    </div>
                    <div class="info-item">
                        <strong>Server Software:</strong>
                        <span><?php echo htmlspecialchars($server_info); ?></span>
                    </div>
                    <div class="info-item">
                        <strong>Site Status:</strong>
                        <span>✅ Online and Running</span>
                    </div>
                </div>
            </section>
            
            <section class="demo">
                <h2>PHP Demo</h2>
                <p>Here's a simple PHP calculation:</p>
                <div class="calculation">
                    <?php
                    $a = 15;
                    $b = 25;
                    $sum = $a + $b;
                    echo "<p>{$a} + {$b} = <strong>{$sum}</strong></p>";
                    ?>
                </div>
            </section>
            
            <section class="links">
                <h2>Navigation</h2>
                <nav>
                    <a href="index.html">Static HTML Version</a>
                    <a href="info.php">PHP Info Page</a>
                </nav>
            </section>
        </main>
        
        <footer>
            <p>&copy; <?php echo date('Y'); ?> <?php echo htmlspecialchars($site_name); ?>. Powered by PHP <?php echo $php_version; ?>.</p>
        </footer>
    </div>
    
    <script src="main.js"></script>
</body>
</html>
