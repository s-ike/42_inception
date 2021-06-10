FROM alpine:3.12

# ensure www-data user exists
RUN set -eux; \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -D -S -G www-data www-data; \
    mkdir -p /usr/src

RUN apk add --no-cache \
        curl \
        tar \
        bash \
        sed \
        ghostscript \
        imagemagick \
        php \
        php-fpm \
        php-mysqli \
        php7-gd \
        php7-imagick \
        php7-iconv \
        php7-dom \
        php-curl \
        php-json \
        php-mbstring \
        php-exif \
        php-fileinfo \
        php7-sodium \
        openssl \
        pcre \
        php-xml \
        php-zip \
        php7-phar \
        mysql-client \
    && rm -f /var/cache/apk/*

RUN set -eux \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
    [ ! -d /var/www/html ]; \
    mkdir -p /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 777 /var/www/html

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p "$PHP_INI_DIR/conf.d"

WORKDIR /var/www/html

RUN sed -ie 's/^user = nobody$/user = www-data/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^group = nobody$/user = www-data/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^listen = 127.0.0.1:9000/listen = 9000/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^;clear_env = no$/clear_env = no/' /etc/php7/php-fpm.d/www.conf

# wp-cli
RUN set -eux; \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
    chmod +x wp-cli.phar; \
    mv wp-cli.phar /usr/local/bin/wp; \
    wp --allow-root --version

VOLUME /var/www/html

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm7", "--nodaemonize"]
