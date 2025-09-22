<?php
// Test script to verify PHP zip extension is working
echo "<h1>PHP Zip Extension Test</h1>";

// Check if zip extension is loaded
if (extension_loaded('zip')) {
    echo "<p style='color: green;'>✓ Zip extension is loaded successfully!</p>";
    
    // Get zip extension info
    $zipInfo = new ReflectionExtension('zip');
    echo "<h2>Zip Extension Information:</h2>";
    echo "<ul>";
    echo "<li><strong>Version:</strong> " . $zipInfo->getVersion() . "</li>";
    echo "<li><strong>Functions:</strong> " . count($zipInfo->getFunctions()) . " functions available</li>";
    echo "</ul>";
    
    // Test basic zip functionality
    echo "<h2>Basic Functionality Test:</h2>";
    try {
        $zip = new ZipArchive();
        echo "<p style='color: green;'>✓ ZipArchive class is available</p>";
        
        // List some available functions
        $functions = ['zip_open', 'zip_read', 'zip_close', 'zip_entry_name', 'zip_entry_read'];
        echo "<p><strong>Available functions:</strong></p><ul>";
        foreach ($functions as $func) {
            if (function_exists($func)) {
                echo "<li style='color: green;'>✓ $func</li>";
            } else {
                echo "<li style='color: orange;'>⚠ $func (not available)</li>";
            }
        }
        echo "</ul>";
        
    } catch (Exception $e) {
        echo "<p style='color: red;'>✗ Error testing ZipArchive: " . $e->getMessage() . "</p>";
    }
    
} else {
    echo "<p style='color: red;'>✗ Zip extension is NOT loaded!</p>";
}

// Show all loaded extensions
echo "<h2>All Loaded Extensions:</h2>";
$extensions = get_loaded_extensions();
sort($extensions);
echo "<p>Total extensions loaded: " . count($extensions) . "</p>";
echo "<ul>";
foreach ($extensions as $ext) {
    if (strtolower($ext) === 'zip') {
        echo "<li style='color: green; font-weight: bold;'>$ext</li>";
    } else {
        echo "<li>$ext</li>";
    }
}
echo "</ul>";
?>
