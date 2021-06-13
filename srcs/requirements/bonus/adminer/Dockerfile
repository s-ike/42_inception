FROM alpine:3.12

RUN set -eux; \
    addgroup -S adminer; \
    adduser -S -G adminer adminer; \
    mkdir -p /var/www/html/adminer; \
    chown -R adminer:adminer /var/www/html/adminer

RUN apk add --no-cache \
        curl \
        php7 \
        php7-fpm \
        php7-mysqli \
        mysql-client \
        postgresql-dev \
        sqlite-dev \
        unixodbc-dev \
        freetds-dev \
        php7-pdo \
        php7-pdo_sqlite \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-session \
    && rm -f /var/cache/apk/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p "$PHP_INI_DIR/conf.d"

WORKDIR /var/www/html/adminer

RUN sed -ie 's/^user = nobody$/user = adminer/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^group = nobody$/user = adminer/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^listen = 127.0.0.1:9000/listen = 9090/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^;clear_env = no$/clear_env = no/' /etc/php7/php-fpm.d/www.conf

VOLUME /var/www/html/adminer

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 9090

CMD ["php-fpm7", "--nodaemonize"]
