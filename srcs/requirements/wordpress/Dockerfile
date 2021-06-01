FROM alpine:3.12

# ensure www-data user exists
RUN set -eux; \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -D -S -G www-data www-data; \
    mkdir -p /usr/src

RUN apk add --no-cache \
        curl \
        tar \
        php-fpm \
        bash \
        sed \
        ghostscript \
        imagemagick \
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
    #  \
    # && chown -R www-data:www-data /var/www/html/*

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

RUN set -eux; \
    version='5.7.2'; \
    sha1='c97c037d942e974eb8524213a505268033aff6c8'; \
    \
    curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"; \
    echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; \
    \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
    tar -xzf wordpress.tar.gz -C /usr/src/; \
    rm wordpress.tar.gz; \
    \
# https://wordpress.org/support/article/htaccess/
    [ ! -e /usr/src/wordpress/.htaccess ]; \
    { \
        echo '# BEGIN WordPress'; \
        echo ''; \
        echo 'RewriteEngine On'; \
        echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'; \
        echo 'RewriteBase /'; \
        echo 'RewriteRule ^index\.php$ - [L]'; \
        echo 'RewriteCond %{REQUEST_FILENAME} !-f'; \
        echo 'RewriteCond %{REQUEST_FILENAME} !-d'; \
        echo 'RewriteRule . /index.php [L]'; \
        echo ''; \
        echo '# END WordPress'; \
    } > /usr/src/wordpress/.htaccess; \
	\
	chown -R www-data:www-data /usr/src/wordpress; \
# pre-create wp-content (and single-level children) for folks who want to bind-mount themes, etc so permissions are pre-created properly instead of root:root
# wp-content/cache: https://github.com/docker-library/wordpress/issues/534#issuecomment-705733507
	mkdir wp-content; \
    for dir in /usr/src/wordpress/wp-content/*/ cache; do \
        dir="$(basename "${dir%/}")"; \
        mkdir "wp-content/$dir"; \
    done; \
    chown -R www-data:www-data wp-content; \
    chmod -R 777 wp-content

VOLUME /var/www/html

COPY --chown=www-data:www-data conf/wp-config-docker.php /usr/src/wordpress/
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm7", "--nodaemonize"]
