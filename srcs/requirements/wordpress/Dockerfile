FROM alpine:3.12

# ensure www-data user exists
RUN set -eux; \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -D -S -G www-data www-data

ENV PHP_INI_DIR /usr/local/etc/php
RUN set -eux \
    mkdir -p "$PHP_INI_DIR/conf.d"; \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
	[ ! -d /var/www/html ]; \
	mkdir -p /var/www/html; \
	chown www-data:www-data /var/www/html; \
	chmod 777 /var/www/html

RUN apk add --no-cache \
        curl \
        php-fpm \
        php-mysqli \
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
        php-zip

COPY --chown=www-data:www-data tools/latest.tar.gz /
RUN tar -xzf latest.tar.gz \
    && rm latest.tar.gz \
    && mv wordpress/* /var/www/html

# chmod -R 777 wp-content

COPY --chown=www-data:www-data conf/wp-config.php /var/www/html/

RUN sed -ie 's/^listen = 127.0.0.1:9000/listen = 9000/' /etc/php7/php-fpm.d/www.conf \
    && sed -ie 's/^;clear_env = no$/clear_env = no/' /etc/php7/php-fpm.d/www.conf \
    && chown -R www-data:www-data /var/www/html/*

STOPSIGNAL SIGQUIT

EXPOSE 9000
VOLUME ["/var/www/html"]
CMD ["php-fpm7", "--nodaemonize"]
