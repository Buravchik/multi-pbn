#!/bin/bash

# Fix permissions for Archivarix CMS and other PHP applications
# This script ensures PHP-FPM can write to the site directories

echo "🔧 Fixing file permissions for PHP applications..."

# Get the PHP-FPM user from the container
PHP_USER=$(docker compose exec php-fpm id -u)
PHP_GROUP=$(docker compose exec php-fpm id -g)

echo "📋 PHP-FPM runs as user: $PHP_USER, group: $PHP_GROUP"

# Fix ownership for all site directories
echo "📁 Fixing ownership for site directories..."
sudo chown -R $PHP_USER:$PHP_GROUP /opt/multi-site/sites/

# Set proper permissions
echo "🔐 Setting proper permissions..."
sudo chmod -R 755 /opt/multi-site/sites/
sudo chmod -R 775 /opt/multi-site/sites/*/

# Make sure PHP-FPM can write to the directories
echo "✍️  Ensuring write permissions..."
sudo chmod -R 775 /opt/multi-site/sites/*/

# Show the results
echo "✅ Permissions fixed! Here's the current ownership:"
ls -la /opt/multi-site/sites/

echo ""
echo "🎉 Archivarix CMS should now be able to write to the directories!"
echo "💡 If you still have issues, try refreshing the Archivarix CMS page."
