FROM alpine:latest

EXPOSE 1194/udp

ADD init.sh /etc/openvpn/init.sh
ADD pem.py /etc/openvpn/pem.py

RUN apk add openvpn bash easy-rsa python3

CMD ["bash", "/etc/openvpn/init.sh"]
