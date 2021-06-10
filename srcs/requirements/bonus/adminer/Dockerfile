FROM alpine:3.12

RUN set -eux; \
    addgroup -S adminer; \
    adduser -S -G adminer adminer; \
    mkdir -p /var/www/html/adminer; \
    mkdir -p /var/www/html/adminer/plugins-enabled; \
    chown -R adminer:adminer /var/www/html/adminer

RUN apk add --no-cache \
        curl \
        tar \
        php \
        php-fpm \
        php-mysqli \
        mysql-client \
        postgresql-dev \
        sqlite-dev \
        unixodbc-dev \
        freetds-dev \
        php-pdo \
        php-pdo_sqlite \
        php-pdo_mysql \
        php-pdo_pgsql \
        php-session \
    && rm -f /var/cache/apk/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p "$PHP_INI_DIR/conf.d"

WORKDIR /var/www/html/adminer

RUN sed -ie 's/^user = nobody$/user = adminer/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^group = nobody$/user = adminer/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^listen = 127.0.0.1:9000/listen = 9090/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^;clear_env = no$/clear_env = no/' /etc/php7/php-fpm.d/www.conf

# adminer
ENV	ADMINER_VERSION 4.8.1
ENV	ADMINER_DOWNLOAD_SHA256 2fd7e6d8f987b243ab1839249551f62adce19704c47d3d0c8dd9e57ea5b9c6b3
ENV	ADMINER_SRC_DOWNLOAD_SHA256 ef832414296d11eed33e9d85fff3fb316c63f13f05fceb4a961cbe4cb2ae8712
RUN set -eux; \
    curl -fsSL https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php -o index.php; \
    echo "$ADMINER_DOWNLOAD_SHA256  index.php" |sha256sum -c -;
COPY conf/adminer.css .

VOLUME /var/www/html/adminer

EXPOSE 9090

CMD ["php-fpm7", "--nodaemonize"]
