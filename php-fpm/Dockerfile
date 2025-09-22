FROM php:8.2-fpm-alpine

# Install the PHP extension installer script
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions

# Install PHP zip extension using the installer
RUN install-php-extensions zip

# Verify the extension is installed
RUN php -m | grep -i zip
