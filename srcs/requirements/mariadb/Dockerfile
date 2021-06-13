FROM alpine:3.12

RUN apk add --update --no-cache \
        mariadb \
        mariadb-client \
        mariadb-server-utils \
        pwgen \
    && rm -f /var/cache/apk/*

COPY tools/docker-entrypoint.sh /tmp/.
RUN chmod -R 755 /tmp/docker-entrypoint.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/tmp/docker-entrypoint.sh"]
