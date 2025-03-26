FROM php:7.4

# Install system dependencies and GD extension
RUN apt-get update -y && apt-get install -y \
    openssl zip unzip git libpng-dev libjpeg-dev libfreetype6-dev

# Install PHP Extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www
COPY . /var/www

# Install Laravel dependencies
RUN composer install

CMD php artisan serve --host=0.0.0.0 --port=9000
EXPOSE 9000
