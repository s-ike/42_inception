FROM alpine:3.12

RUN apk add --update --no-cache \
        mariadb \
        mariadb-client \
        mariadb-server-utils \
        pwgen && \
    rm -f /var/cache/apk/*

ADD tools/init_db.sh /tmp/init_db.sh
RUN chmod -R 755 /tmp/init_db.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/tmp/init_db.sh"]
