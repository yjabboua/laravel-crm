FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    cron

# Install PHP extensions
#--------------------------
RUN docker-php-ext-install pdo_mysql

# Setup the crontab
#--------------------------
COPY .docker/cron/cron.d/laravel-cron /etc/cron.d/laravel-cron

RUN chmod 0644 /etc/cron.d/laravel-cron
RUN crontab /etc/cron.d/laravel-cron

RUN touch /var/log/cron.log

# Cleaning
#--------------------------
RUN apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["cron", "&&", "tail", "-f", "/var/log/cron.log"]
