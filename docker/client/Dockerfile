FROM alpine:latest

WORKDIR /root

RUN apk add openvpn && \
    mkdir /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    openvpn --config /etc/openvpn/client.ovpn
