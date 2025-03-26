# Use PHP 7.4 FPM as the base image
FROM php:7.4-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy application code into the container
COPY . /var/www

# Install dependencies, optimize, and set permissions
RUN composer install --prefer-dist --no-dev --optimize-autoloader \
    && php artisan config:cache \
    && php artisan view:cache \
    && chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Generate .env if missing (for development)
RUN if [ ! -f ".env" ]; then cp .env.example .env && php artisan key:generate; fi

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]