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
    # mkdir -p "$PHP_INI_DIR/conf.d"; \
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

# https://wordpress.org/support/article/editing-wp-config-php/#configure-error-logging
RUN { \
# https://www.php.net/manual/en/errorfunc.constants.php
# https://github.com/docker-library/wordpress/issues/420#issuecomment-517839670
        echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
        echo 'display_errors = Off'; \
        echo 'display_startup_errors = Off'; \
        echo 'log_errors = On'; \
        echo 'error_log = /dev/stderr'; \
        echo 'log_errors_max_len = 1024'; \
        echo 'ignore_repeated_errors = On'; \
        echo 'ignore_repeated_source = Off'; \
        echo 'html_errors = Off'; \
    } > /usr/local/etc/php/conf.d/error-logging.ini

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
