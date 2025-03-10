FROM alpine:3.20

RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    curl \
    bash

RUN mkdir -p /run/nginx && \
    mkdir -p /var/www/html && \
    chown -R nginx:nginx /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/http.d/default.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/private/certificate.crt -subj \
    "/C=FR/ST=Normandie/L=Le Havre/O=Inception/OU=42/CN=$DOMAIN"

EXPOSE 443

CMD ["nginx" , "-g", "daemon off;"]