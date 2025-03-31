#!/bin/bash

DB_DIR="/var/lib/mysql"
CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"

initialize_database() {
    if [ ! -d "$DB_DIR/mysql" ]; then
        echo "Initializing MariaDB database..."
        mariadb-install-db --user=mysql --basedir=/usr --datadir="$DB_DIR" || {
            echo "Error: Failed to initialize database."
            exit 1
        }
    else
        echo "Database already initialized."
    fi
}

configure_mariadb() {
    echo "Configuring MariaDB settings..."
    sed -i "s|bind-address\s*=\s*127.0.0.1|bind-address = 0.0.0.0|g" "$CONF_FILE"
}

start_mysql() {
    echo "Starting MariaDB..."
    mysqld_safe --datadir="$DB_DIR" &

    local retries=30
    until mysqladmin ping &>/dev/null || [ $retries -eq 0 ]; do
        echo "Waiting for MariaDB to start..."
        sleep 1
        ((retries--))
    done

    if [ $retries -eq 0 ]; then
        echo "Error: MariaDB did not start in time."
        exit 1
    fi
}

setup_database() {
    echo "Configuring database and users..."

    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_ADMIN_USER}'@'%';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;"

    mysql -e "FLUSH PRIVILEGES;"
}

initialize_database
configure_mariadb
start_mysql
setup_database

echo "MariaDB setup complete!"
wait
