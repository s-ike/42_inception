FROM alpine:3.13

RUN apk --no-cache add \
        redis \
    && rm -f /var/cache/apk/*

RUN set -eux; \
    sed -ie 's/protected-mode yes/protected-mode no/' /etc/redis.conf; \
    sed -ie 's/^\(bind .*\)$/# \1/' /etc/redis.conf; \
    sed -ie 's/^\(daemonize .*\)$/# \1/' /etc/redis.conf; \
    sed -ie 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis.conf;

VOLUME /data

WORKDIR /data

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis.conf"]
