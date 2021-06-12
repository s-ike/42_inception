FROM alpine:3.12

RUN apk add --no-cache \
        nginx \
        openssl \
    && rm -f /var/cache/apk/*

RUN set -eux; \
    mkdir /etc/ssl/self; \
    openssl genrsa \
        -out /etc/ssl/self/cakey.pem 2048; \
    openssl req -new \
        -subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/CN=localhost" \
        -key /etc/ssl/self/cakey.pem \
        -out /etc/ssl/self/cacert.csr; \
    openssl x509 \
        -days 3650 \
        -in /etc/ssl/self/cacert.csr -req \
        -signkey /etc/ssl/self/cakey.pem \
        -out /etc/ssl/self/cacert.pem; \
    chmod 400 /etc/ssl/self/cakey.pem

RUN mkdir -p /run/nginx

EXPOSE 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
