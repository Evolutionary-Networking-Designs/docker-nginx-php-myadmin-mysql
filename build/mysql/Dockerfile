FROM mysql:5

RUN groupmod -g 83 mysql
RUN usermod -u 83 mysql
RUN id mysql

RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

VOLUME /var/lib/mysql

RUN mkdir /export
RUN chown -R mysql:mysql /export

COPY docker-entrypoint.sh /usr/local/bin/
RUN rm -f /entrypoint.sh
RUN ln -sf /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 33060
CMD ["mysqld"]
