FROM alpine:3.13

RUN apk add --no-cache \
        vim \
        git \
        make \
        musl-dev \
        go \
    && rm -f /var/cache/apk/*

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN mkdir -p /go/src/github.com/myweb

RUN set -eux; \
    go mod init github.com/myweb; \
    go get -u github.com/gorilla/mux;

WORKDIR /go/src/github.com/myweb/

CMD ["go", "run", "main.go"]
