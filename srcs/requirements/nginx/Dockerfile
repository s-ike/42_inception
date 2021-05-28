FROM alpine:3.12

RUN apk add --no-cache \
        nginx \
        openssl \
    && rm -f /var/cache/apk/*

RUN mkdir /etc/ssl/self \
    && openssl req \
        -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/ssl/self/selfsigned.key \
        -out /etc/ssl/self/selfsigned.crt \
        -subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/CN=localhost"

RUN mkdir -p /run/nginx

EXPOSE 80 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
