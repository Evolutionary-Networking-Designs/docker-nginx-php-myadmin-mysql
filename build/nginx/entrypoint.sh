#!/bin/bash
set -e

if [[ -z ${1} ]]; then
  chown www-data:www-data /etc/nginx
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
