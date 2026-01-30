FROM php:8.1-apache



RUN apt-get update
RUN apt-get install unzip -y && apt-get install curl -y
# Install extensions needed by Q2A
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable mod_rewrite
RUN a2enmod rewrite

# Install Redis PHP extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# PHP session config for Redis
RUN echo "session.save_handler = redis" > /usr/local/etc/php/conf.d/redis-session.ini \
    && echo 'session.save_path = "tcp://redis:6379"' >> /usr/local/etc/php/conf.d/redis-session.ini

# Download Q2A

# Set working directory

WORKDIR /var/www/html

# Download and extract Question2Answer

RUN curl -L https://github.com/q2a/question2answer/archive/refs/heads/master.zip  -o q2a.zip \
    && unzip q2a.zip \
    && ls -la \
    && mv question2answer-*/* . \
    && mv question2answer-*/.htaccess-example .htaccess \
    && rm -rf question2answer-* q2a.zip 

# Configure Q2A

RUN mv qa-config-example.php qa-config.php 

# Set permissions
# ✅ CLEAN APACHE PERMISSIONS
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;





# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make it executable
RUN chmod +x /entrypoint.sh

# Use entrypoint
ENTRYPOINT ["/entrypoint.sh"]








EXPOSE 80
CMD ["apache2-foreground"]

## In case of need:     https://github.com/q2a/question2answer/archive/refs/heads/bugfix.zip 
# https://www.question2answer.org/question2answer-latest.zip 
# https://github.com/q2a/question2answer/archive/refs/heads/bugfix.zip question2answer-*/*