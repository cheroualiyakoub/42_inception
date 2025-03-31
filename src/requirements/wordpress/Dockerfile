FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    net-tools php-fpm php-mysql wget unzip curl mariadb-client && \
    apt-get clean


RUN	mkdir -p /var/www/html && \
	 wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    chown -R www-data:www-data  /var/www/html && \
    chmod -R 755 /var/www/html && \
    rm -rf wordpress latest.tar.gz

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN sed -i "s|listen = /run/php/php.*-fpm.sock|listen = 9000|g" /etc/php/*/fpm/pool.d/www.conf && \
    sed -i "s|;listen.owner = www-data|listen.owner = www-data|g" /etc/php/*/fpm/pool.d/www.conf && \
    sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php/*/fpm/pool.d/www.conf

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

COPY ./conf/backup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

WORKDIR /var/www/html

CMD ["/bin/bash", "-c", "/usr/local/bin/setup.sh && php-fpm7.4 --nodaemonize"]
