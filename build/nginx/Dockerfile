FROM nginx:latest

LABEL maintainer="Kevin Meredith <kevin@meredithkm.info>"

ADD entrypoint.sh /entrypoint.sh
ADD nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /entrypoint.sh
RUN userdel www-data
RUN groupadd -g 82 www-data
RUN useradd -u 82 -g 82 www-data

ENTRYPOINT ["/entrypoint.sh"]
