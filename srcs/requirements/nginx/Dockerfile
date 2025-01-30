FROM nginx:alpine

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY ssl /etc/nginx/ssl

EXPOSE 443

CMD ["nginx" , "-g", "daemon off;"]