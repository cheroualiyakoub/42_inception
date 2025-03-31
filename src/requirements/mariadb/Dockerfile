FROM mariadb:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./conf/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]
