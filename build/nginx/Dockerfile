FROM nginx:latest

LABEL maintainer="Kevin Meredith <kevin@meredithkm.info>"

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y openssl

ADD ssl-config /ssl-config
ADD entrypoint.sh /entrypoint.sh
ADD nginx.conf /etc/nginx/nginx.conf
ADD conf.d /etc/nginx/conf.d
ADD error /var/www/html/error
RUN chmod +x /entrypoint.sh
RUN userdel www-data
RUN groupadd -g 82 www-data
RUN useradd -u 82 -g 82 www-data

ENTRYPOINT ["/entrypoint.sh"]
