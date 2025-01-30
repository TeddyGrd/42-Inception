FROM alpine:3.21

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && apk upgrade

RUN apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-curl \
    php82-openssl \
    php82-mbstring \
    php82-json \
    php82-xml \
    php82-session \
    php82-tokenizer \
    php82-gd \
    php82-zip \
    mysql-client \
    bash \
    curl \
    openssl \
    net-tools \
    iputils \
    && rm -rf /var/cache/apk/*

RUN addgroup -S www-data || true && adduser -S www-data -G www-data || true

RUN mkdir -p /var/log/php82 && chown -R www-data:www-data /var/log/php82

RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY conf/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY conf/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 9000

USER www-data

ENTRYPOINT ["/entrypoint.sh"]
