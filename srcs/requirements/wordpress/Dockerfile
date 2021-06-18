FROM alpine:3.12

# ensure www-data user exists
RUN set -eux; \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -D -S -G www-data www-data; \
    mkdir -p /usr/src

RUN apk add --no-cache \
        curl \
        bash \
        sed \
        ghostscript \
        imagemagick \
        php7 \
        php7-fpm \
        php7-mysqli \
        php7-gd \
        php7-imagick \
        php7-iconv \
        php7-dom \
        php7-curl \
        php7-json \
        php7-mbstring \
        php7-exif \
        php7-fileinfo \
        php7-sodium \
        openssl \
        pcre \
        php7-xml \
        php7-zip \
        php7-phar \
        mysql-client \
        redis \
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
    && sed -ie 's/^;\(clear_env = no\)$/\1/' /etc/php7/php-fpm.d/www.conf

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
