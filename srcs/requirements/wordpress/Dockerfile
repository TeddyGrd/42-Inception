FROM alpine:3.20

RUN apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-pecl-igbinary \
    php82-openssl \
    php82-mbstring \
    php82-json \
    php82-xml \
    php82-session \
    php82-tokenizer \
    php82-gd \
    php82-zip \
    php82-phar \
    php82-iconv \
    php82-shmop \
    php82-cli \
    mysql-client \
    php82-simplexml \
    php82-sodium \
    mariadb-client \
    bash \
    curl \
    nano \
    openssl \
    net-tools \
    inetutils-telnet \
    iputils \
    && rm -rf /var/cache/apk/*

RUN cd /usr/local/bin/ && \
    curl -o wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp

RUN echo "memory_limit=256M" > /etc/php82/conf.d/memory.ini

RUN addgroup -S www-data || true && adduser -S www-data -G www-data || true

RUN sed -i 's/user = nobody/user = www-data/' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's/group = nobody/group = www-data/' /etc/php82/php-fpm.d/www.conf &&\
    sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

COPY conf/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
