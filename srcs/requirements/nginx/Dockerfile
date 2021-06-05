FROM alpine:3.12

RUN apk add --no-cache \
        nginx \
        openssl \
    && rm -f /var/cache/apk/*

RUN mkdir /etc/ssl/self; \
    openssl genrsa -out /etc/ssl/self/privkey.pem 2048; \
    openssl req \
        -subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/CN=localhost" \
        -new -key /etc/ssl/self/privkey.pem \
        -out /etc/ssl/self/selfsigned.csr; \
    openssl x509 -days 825 \
        -req \
        -signkey /etc/ssl/self/privkey.pem \
        -in /etc/ssl/self/selfsigned.csr \
        -out /etc/ssl/self/selfsigned.pem;
    # openssl ca \
    #     -in /etc/ssl/self/domain_name.csr \
    #     -out /etc/pki/tls/certs/domain_name.crt.pem \
    #     -days 825
    # openssl req \
    #     -x509 \
    #     -nodes \
    #     -days 365 \
    #     -newkey rsa:2048 \
    #     -keyout /etc/ssl/self/selfsigned.key \
    #     -out /etc/ssl/self/selfsigned.crt \
    #     -subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/CN=localhost"

RUN mkdir -p /run/nginx

EXPOSE 80 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
