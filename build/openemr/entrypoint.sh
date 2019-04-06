#!/bin/sh
set -e

# Generate sqlconf.php
cat /openemr-config/sqlconf.tmpl | \
      sed "s|OPENEMR_DB_HOST|$OPENEMR_DB_HOST|g" | \
      sed "s|OPENEMR_DB_PORT|$OPENEMR_DB_PORT|g" | \
      sed "s|OPENEMR_LOGIN|$OPENEMR_LOGIN|g" | \
      sed "s|OPENEMR_PASS|$OPENEMR_PASS|g" | \
      sed "s|OPENEMR_DBASE|$OPENEMR_DBASE|g" | \
      sed "s|OPENEMR_CONFIG|$OPENEMR_CONFIG|g" > /openemr-config/sqlconf.php

if [ ! -f /var/www/html/openemr/version.txt ]; then
	touch /var/www/html/openemr/version.txt
fi

MOUNT_VERSION=$(cat /var/www/html/openemr/version.txt)

if [ "$MOUNT_VERSION" != "$OPENEMR_BRANCH" ]; then
	rsync -av --exclude documents/ --exclude edi/ --exclude era/ --exclude letter-templates /openemr/ /var/www/html/openemr/
	echo $OPENEMR_BRANCH > /var/www/html/openemr/version.txt
fi

cp /openemr-config/sqlconf.php /var/www/html/openemr/sites/default/sqlconf.php
cp /staging/config.$OPENEMR_BRANCH /openemr-config/config.$OPENEMR_BRANCH

if [ -f /openemr-config/config.php ]; then
	cp /openemr-config/config.php /var/www/html/openemr/sites/default/config.php
fi

chown -R www-data:www-data /var/www/html/openemr/

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
