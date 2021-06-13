#!/bin/bash
set -eu

if [ "$1" = 'php-fpm7' ]; then
	uid="$(id -u)"
	gid="$(id -g)"
	if [ "$uid" = '0' ]; then
		user='www-data'
		group='www-data'
	else
		user="$uid"
		group="$gid"
	fi

	if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
		# if the directory exists and WordPress doesn't appear to be installed AND the permissions of it are root:root, let's chown it (likely a Docker-created directory)
		if [ "$uid" = '0' ] && [ "$(stat -c '%u:%g' .)" = '0:0' ]; then
			chown "$user:$group" .
		fi

		echo >&2 "WordPress not found in $PWD - download now..."
		wp core download \
			--locale=ja
		if [ $? -eq 0 ]; then
			chown -R www-data:www-data /var/www/html
			chmod -R 777 wp-content
		else
			exit 1
		fi
		echo >&2 "Complete! WordPress has been successfully downloaded to $PWD"

		echo "Waiting for database"
		until mysql -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" &> /dev/null; do
			>&2 echo -n "."
			sleep 1
		done
		>&2 echo "Database is up"

		if [ ! -s wp-config.php ]; then
			wp config create \
				--dbname=${WORDPRESS_DB_NAME} \
				--dbuser=${WORDPRESS_DB_USER} \
				--dbpass=${WORDPRESS_DB_PASSWORD} \
				--dbhost=${WORDPRESS_DB_HOST} \
				--force \
				--allow-root \
				--extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', true );
ini_set( 'display_errors', 1 );
ini_set( 'log_errors', 1 );
ini_set( 'error_log', '/var/log/wordpress/error.log');
define( 'JETPACK_DEV_DEBUG', true );
PHP
		fi

		wp core install \
			--url=${DOMAIN_NAME} \
			--title=${WORDPRESS_WEBSITE_TITLE} \
			--admin_user=${WORDPRESS_ADMIN_USER} \
			--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
			--admin_email=${WORDPRESS_ADMIN_EMAIL} \
			--allow-root

		wp user create ${WORDPRESS_EDITOR_USER} ${WORDPRESS_EDITOR_EMAIL} \
			--user_pass=${WORDPRESS_EDITOR_PASSWORD} \
			--role=${WORDPRESS_EDITOR_ROLE} \
			--allow-root

		wp plugin delete hello.php --allow-root
	fi
fi

exec "$@"
