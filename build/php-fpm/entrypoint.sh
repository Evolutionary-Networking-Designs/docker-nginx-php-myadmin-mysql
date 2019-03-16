#!/bin/bash
set -e

mv /var/www/html/composer.phar /var/www/app/

# fix permission for mounted volume
chown www-data:www-data /var/www/app

echo 'start'
exec "$@"
