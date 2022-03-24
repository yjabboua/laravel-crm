#!/bin/sh

set -e

# ----------------------------------------------------------------------
# Create the .env file if it does not exist.
# ----------------------------------------------------------------------

if [[ ! -f "/var/www/html/.env" ]] && [[ -f "/var/www/html/.env.example" ]]; then
  cp /var/www/html/.env.example /var/www/html/.env
fi

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------

composer install --no-interaction --no-progress --prefer-dist

# ----------------------------------------------------------------------
# Run Yarn
# ----------------------------------------------------------------------
#yarn install
#yarn run dev

# ----------------------------------------------------------------------
# Run
# ----------------------------------------------------------------------
if [ $# -gt 0 ]; then
    # If we passed a command, run it
    exec "$@"
else
    # Otherwise start supervisord
    /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
fi