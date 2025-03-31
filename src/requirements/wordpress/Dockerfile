FROM debian:bullseye

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    net-tools \
    php-fpm \
    php-mysql \
    wget \
    unzip \
    curl \
    mariadb-client && \
    apt-get clean

# Set up WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm -rf wordpress latest.tar.gz

# Set permissions for WordPress files
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on port 9000
RUN sed -i "s|listen = /run/php/php.*-fpm.sock|listen = 9000|g" /etc/php/*/fpm/pool.d/www.conf && \
    sed -i "s|;listen.owner = www-data|listen.owner = www-data|g" /etc/php/*/fpm/pool.d/www.conf && \
    sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php/*/fpm/pool.d/www.conf

# Create necessary directories and set permissions
RUN mkdir -p /run/php && \
    chown -R www-data:www-data /run/php

# Copy the setup script and make it executable
COPY ./conf/backup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Expose the PHP-FPM port
EXPOSE 9000

# Set the working directory
WORKDIR /var/www/html

# Set the command to run on container start
CMD ["/bin/bash", "-c", "/usr/local/bin/setup.sh && php-fpm7.4 --nodaemonize"]
