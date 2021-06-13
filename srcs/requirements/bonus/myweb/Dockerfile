FROM golang:alpine3.12

RUN apk add --no-cache \
        git

ENV GOPATH=
RUN set -eux; \
    go mod init github.com/myweb; \
    go mod tidy; \
    go get -u github.com/gorilla/mux;

WORKDIR /go/src/github.com/myweb/

CMD ["go", "run", "main.go"]
