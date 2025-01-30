FROM alpine:3.21

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    bash

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER mysql

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]