FROM nginx:1.23.3-alpine
ADD docker/nginx/conf.d/default.conf /etc/nginx/conf.d

RUN chmod -R 0777 /var/www/storage
