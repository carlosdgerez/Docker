#!/bin/sh
set -e
## Entrypoint script for Q2A Docker container to configure database settings
# based on environment variables.
# Environment Variables:


INSTALL_DIR=/var/www/html
CONFIG_FILE="$INSTALL_DIR/qa-config.php"

echo "Configuring Q2A database settings..."


# Even if is a space before the settings line in the congiguration file it will update the settings

sed -i "s|^[[:space:]]*define('QA_MYSQL_HOSTNAME'.*|        define('QA_MYSQL_HOSTNAME', '${DB_HOST}');|" "$CONFIG_FILE"
sed -i "s|^[[:space:]]*define('QA_MYSQL_USERNAME'.*|        define('QA_MYSQL_USERNAME', '${DB_USER}');|" "$CONFIG_FILE"
sed -i "s|^[[:space:]]*define('QA_MYSQL_PASSWORD'.*|        define('QA_MYSQL_PASSWORD', '${DB_PASS}');|" "$CONFIG_FILE"
sed -i "s|^[[:space:]]*define('QA_MYSQL_DATABASE'.*|        define('QA_MYSQL_DATABASE', '${DB_NAME}');|" "$CONFIG_FILE"

echo "Q2A configuration updated successfully."

# Start Apache in the foreground
exec apache2-foreground

# Install and enable Redis extension for PHP 
# This is to store sessions for multiple containers configurations.
RUN pecl install redis \
 && docker-php-ext-enable redis


# PHP session config for Redis
RUN echo "session.save_handler = redis" > /usr/local/etc/php/conf.d/redis-session.ini \
    && echo 'session.save_path = "tcp://redis:6379"' >> /usr/local/etc/php/conf.d/redis-session.ini

    # Start Apache in the foreground
exec apache2-foreground