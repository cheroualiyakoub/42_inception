FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server \
    && apt-get clean

COPY ./conf/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]
