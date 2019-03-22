#!/bin/bash
set -e

# Generate dhparam.pem if it doesn't already exist
if [ ! -f /etc/letsencrypt/ssl-dhparams.pem ]; then
    openssl dhparam -dsaparam -out /etc/letsencrypt/ssl-dhparams.pem 4096
fi

# Copy ssl options if it doesn't exist
if [ ! -f /etc/letsencrypt/options-ssl-nginx.conf ]; then
    cp /ssl-config/options-ssl-nginx.conf /etc/letsencrypt/options-ssl-nginx.conf
fi

chown -R www-data:www-data /etc/letsencrypt

if [[ -z ${1} ]]; then
  chown -R www-data:www-data /etc/nginx
  if [[ $ENABLE_WORDPRESS = 1 ]]; then 
    cat /etc/nginx/conf.d/wp.tmpl | sed "s|WORDPRESS_URL|$WORDPRESS_URL|g" > /etc/nginx/conf.d/wp.conf
  fi
  if [[ $NGINX_DEBUG == 1 ]]; then
    echo "Starting nginx in debug mode..."
    exec $(which nginx-debug) -c /etc/nginx/nginx.conf -g "daemon off;"
  else
    echo "Starting nginx..."
    exec $(which nginx) -c /etc/nginx/nginx.conf -g "daemon off;"
  fi
else
  exec "$@"
fi
