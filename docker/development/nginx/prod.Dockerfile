FROM nginx:1.23.3-alpine
COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d
# Copy existing application directory contents
COPY . /var/www

RUN chmod -R 0777 /var/www/storage
