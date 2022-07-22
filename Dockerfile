FROM php:8.1.8-fpm-alpine

# Set working directory
WORKDIR /var/www

RUN apk update && apk add \
    build-base \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    zip \
    vim \
    unzip \
    git \
    jpegoptim optipng pngquant gifsicle \
    curl \
    libmemcached-dev \
    lua-lzlib \
    nginx \
    libpq-dev \
    supervisor 

# Install php extensions
# Add docker php ext repo
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install php extensions
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions mbstring pdo_mysql pdo_pgsql zip exif pcntl memcached

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www -s /bin/sh

# Copy code to /var/www
COPY --chown=www:www-data . /var/www

# add root to www group
RUN chmod -R ug+w /var/www/storage

# Set permissions for cache and logs
RUN chmod -R 775 /var/www/bootstrap/cache /var/www/storage/logs


# Copy nginx/php/supervisor configs
RUN cp docker/supervisor.conf /etc/supervisord.conf
RUN cp docker/php.ini /usr/local/etc/php/conf.d/app.ini
RUN cp docker/nginx.conf /etc/nginx/http.d/default.conf

# PHP Error Log Files (though not used in this example - see docker/supervisor.conf)
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Deployment steps
RUN composer install --optimize-autoloader --no-dev
# AWS dependencies
RUN composer require aws/aws-sdk-php
RUN composer require aws/aws-php-sns-message-validator doctrine/cache

RUN chmod +x /var/www/docker/run.sh

EXPOSE 80
ENTRYPOINT ["/var/www/docker/run.sh"]