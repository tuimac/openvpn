FROM alpine:latest

MAINTAINER tuimac

EXPOSE 1194/udp
EXPOSE 1194/tcp

ADD entrypoint.sh /etc/openvpn/entrypoint.sh
ADD pem.py /etc/openvpn/pem.py

RUN apk add openvpn bash easy-rsa python3 iptables && \
    mkdir /etc/openvpn/data

CMD ["bash", "/etc/openvpn/entrypoint.sh"]
