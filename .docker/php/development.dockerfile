FROM php:8.1-fpm

# Arguments defined in docker-compose.*.yml
#--------------------------
ARG UNAME
ARG UID
ARG NODE_VERSION=16

ENV ENV_UNAME=$UNAME

# Install system dependencies
#--------------------------
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libcap2-bin \
    libonig-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    sqlite3 \
    supervisor \
    unzip \
    vim \
    zip

# Clear cache
#--------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
#--------------------------
RUN docker-php-ext-install \
    bcmath \
    exif \
    gd \
    pcntl \
    pdo_mysql \
    mbstring \
    opcache \
    zip

# Install Redis
#--------------------------
RUN pecl install redis && \
    docker-php-ext-enable redis

# Install Xdebug
#--------------------------
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Copy config files
#--------------------------
COPY .docker/php/conf.d/development/*.ini /usr/local/etc/php/conf.d/

# Get latest Composer
#--------------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
#--------------------------
RUN useradd -G www-data,root -u ${UID} -d /home/${UNAME} ${UNAME}
RUN mkdir -p /home/${UNAME}/.composer && \
    chown -R ${UNAME}:${UNAME} /home/${UNAME}

# Setup Supervisord
#--------------------------
RUN apt-get update && apt-get install -y
COPY .docker/php/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown -R ${UNAME}:${UNAME} /var/log/supervisor/

# Setup Node/Npm/Yarn
#--------------------------
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# Cleaning
#--------------------------
RUN apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the entrypoint shell
#--------------------------
COPY .docker/php/entrypoints/development.sh /usr/local/bin/docker-php-entrypoint
RUN chmod +x /usr/local/bin/docker-php-entrypoint

# Set working directory and User
#--------------------------
WORKDIR /var/www/html
USER ${UNAME}

# Entrypoint
#--------------------------
ENTRYPOINT ["docker-php-entrypoint"]
