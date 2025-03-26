FROM php:7.4-apache

# Install any PHP extensions you need, e.g., mysqli, pdo_mysql:
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy your application code to the container
COPY . /var/www/html/

# Optional: set working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80