FROM php:8.2-fpm
# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y --force-yes install nodejs

#Yarn
# Installing Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libwebp-dev \
    libmagickwand-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    nano \
    curl \
    autoconf \
    libtool \
    make

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd



# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY . /var/www

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/kukun kukun
RUN mkdir -p /home/kukun/.composer && \
    chown -R kukun:kukun /home/kukun

# Set working directory
WORKDIR /var/www

RUN chown -R kukun:kukun /var/www
RUN chmod -R 0777 /var/www/storage

USER kukun

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
