FROM node:19.7-alpine AS frontend

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json package-lock.json ./
# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

RUN \
  if [ -f yarn.lock ]; then yarn; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i; \
  else echo "Lockfile not found." && yarn; \
  fi

COPY ./resources/js ./resources/js
COPY ./resources/sass ./resources/sass
COPY ./resources/css ./resources/css
COPY ./vite.config.js ./

RUN npm run build

FROM composer:2.5.4 as composer
WORKDIR /app
# Copy composer.lock and composer.json
COPY composer.json composer.lock artisan ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts --no-progress --no-suggest

COPY ./app ./app
COPY ./bootstrap ./bootstrap
COPY ./config ./config
COPY ./database ./database
COPY ./public ./public
COPY ./resources ./resources
COPY ./routes ./routes
COPY ./storage ./storage
COPY ./tests ./tests
RUN composer dump-autoload --optimize

FROM php:8.2-fpm-alpine AS runner
# Install system dependencies
RUN apk update && apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    libzip-dev \
    libwebp-dev \
    imagemagick \
    freetype-dev \
    postgresql-dev \
    postgresql-client \
    icu-dev \
    zlib-dev \
    curl \
    autoconf \
    libtool \
    make \
    g++

# Clear cache
RUN rm -rf /var/cache/apk/*
# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install -j$(nproc) pdo_pgsql bcmath gd exif intl zip opcache

ARG WORKDIR='/var/www'
ARG UID='1000'
ARG USER='kukun'
ARG GROUP='kukun'

ENV APP_NAME='Laravel'
ENV APP_ENV=local
ENV APP_KEY='base64:sEhGmd6Skajxha0qq9acL5a5Qh7+HLrElPG1lqK8ZJI='
ENV APP_DEBUG=true
ENV APP_URL='http://localhost'

ENV LOG_CHANNEL=stack
ENV LOG_DEPRECATIONS_CHANNEL=null
ENV LOG_LEVEL=debug

ENV DB_CONNECTION='pgsql'
ENV DB_HOST='127.0.0.1'
ENV DB_PORT='5432'
ENV DB_DATABASE='postgres'
ENV DB_USERNAME='postgres'
ENV DB_PASSWORD='password'

ENV BROADCAST_DRIVER=log
ENV CACHE_DRIVER=file
ENV FILESYSTEM_DISK=local
ENV QUEUE_CONNECTION=sync
ENV SESSION_DRIVER=file
ENV SESSION_LIFETIME=120

ENV MEMCACHED_HOST='127.0.0.1'

ENV REDIS_HOST='127.0.0.1'
ENV REDIS_PASSWORD=null
ENV REDIS_PORT='6379'

ENV MAIL_MAILER=smtp
ENV MAIL_HOST=mailpit
ENV MAIL_PORT=1025
ENV MAIL_USERNAME=null
ENV MAIL_PASSWORD=null
ENV MAIL_ENCRYPTION=null
ENV MAIL_FROM_ADDRESS="hello@example.com"
ENV MAIL_FROM_NAME="${APP_NAME}"

ENV AWS_ACCESS_KEY_ID=null
ENV AWS_SECRET_ACCESS_KEY=null
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_BUCKET=null
ENV AWS_USE_PATH_STYLE_ENDPOINT=false

ENV PUSHER_APP_ID=PUSHER_APP_ID
ENV PUSHER_APP_KEY=null
ENV PUSHER_APP_SECRET=null
ENV PUSHER_HOST=null
ENV PUSHER_PORT=443
ENV PUSHER_SCHEME=https
ENV PUSHER_APP_CLUSTER=mt1

ENV VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
ENV VITE_PUSHER_HOST="${PUSHER_HOST}"
ENV VITE_PUSHER_PORT="${PUSHER_PORT}"
ENV VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
ENV VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

WORKDIR $WORKDIR

COPY --from=composer /app ./
COPY --from=frontend /app/public ./public
COPY docker/production/php/php.ini /usr/local/etc/php/conf.d/php.ini

RUN addgroup -g $UID $GROUP
RUN adduser -D -G $GROUP -u $UID -h /home/$USER -s /bin/sh $USER
RUN mkdir -p /home/$USER/.composer  \
    && chown -R $USER:$GROUP /home/$USER  \
    && chown -R $USER:$GROUP $WORKDIR \
    && chmod -R 0777 $WORKDIR/storage
RUN php artisan route:cache && php artisan view:cache
USER $USER

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
