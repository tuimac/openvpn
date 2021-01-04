FROM alpine:latest

MAINTAINER tuimac

WORKDIR /root

COPY entrypoint.sh /root/entrypoint.sh
COPY test.ovpn /root/test.ovpn

RUN apk update && \
    apk upgrade && \
    apk add --no-cache openvpn bash

ENTRYPOINT ["bash", "/root/entrypoint.sh"]
