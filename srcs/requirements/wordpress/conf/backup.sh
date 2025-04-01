#!/bin/bash

WP_PATH="/var/www/html"
LOG_FILE="/var/log/wp-setup.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

wait_for_mariadb()
{
    log_message "Waiting for MariaDB to start..."
    until mysqladmin ping -h "${MYSQL_DB_HOST}" -u root --password="${MYSQL_ROOT_PASSWORD}" --silent; do
        sleep 1
    done
    log_message "MariaDB is ready!"
}

check_admin_name()
{
    if echo "${WORDPRESS_ADMIN_USER}" | grep -i -qE "admin|administrator|Admin"; then
        echo "Error: WORDPRESS_ADMIN_USER contains forbidden substrings (admin, administrator, Admin)."
        exit 1
    fi
}

configure_wordpress() {
    if [ ! -f "$WP_PATH/wp-config.php" ]; then
        log_message "Creating WordPress config file..."
        wp config create --path="$WP_PATH" \
            --dbname="${MYSQL_DATABASE}" \
            --dbuser="${MYSQL_USER}" \
            --dbpass="${MYSQL_PASSWORD}" \
            --dbhost="${MYSQL_DB_HOST}" \
            --allow-root
    else
        log_message "WordPress config file already exists."
    fi
}

install_wordpress() {
    if ! wp core is-installed --path="$WP_PATH" --allow-root; then
        log_message "Installing WordPress..."
        wp core install --path="$WP_PATH" \
            --url="https://${DOMAIN_NAME}" \
            --title="${WORDPRESS_TITLE}" \
            --admin_user="${WORDPRESS_ADMIN_USER}" \
            --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
            --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
            --skip-email --allow-root

        log_message "WordPress installed successfully."
    else
        log_message "WordPress is already installed."
    fi
}

create_wp_user() {
    if wp user list --path="$WP_PATH" --allow-root | grep -q "${WORDPRESS_USER}"; then
        log_message "User ${WORDPRESS_USER} already exists."
    else
        log_message "Creating subscriber user..."
        wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
            --user_pass="${WORDPRESS_USER_PASSWORD}" --role=subscriber \
            --path="$WP_PATH" --allow-root
        log_message "User ${WORDPRESS_USER} created successfully."
    fi
}

wait_for_mariadb
check_admin_name
configure_wordpress
install_wordpress
create_wp_user

log_message "WordPress setup completed successfully."
