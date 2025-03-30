#!/bin/bash

until mysqladmin ping -h "${MYSQL_DB_HOST}" -u root --password="${MYSQL_ROOT_PASSWORD}" --silent; do
    sleep 1
done

echo "Maria db is ready!"

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Creating wordpress config file..."
    wp config create --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_DB_HOST}" \
        --allow-root
fi


if ! wp core is-installed --path=/var/www/html --allow-root; then
    wp core install --path=/var/www/html \
        --url=https://${DOMAIN_NAME} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email --allow-root

    echo "Creating user..."
    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="${WORDPRESS_USER_PASSWORD}" --role=subscriber \
        --path=/var/www/html --allow-root

    echo "WordPress installed."
fi
