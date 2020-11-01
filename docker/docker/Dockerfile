FROM alpine:latest

EXPOSE 1194/udp
EXPOSE 1194/tcp

RUN apk add openvpn bash easy-rsa python3
ADD scripts/init.sh /etc/openvpn/init.sh
ADD scripts/createCert.sh /etc/openvpn/createCert.sh
ADD scripts/pem.py /etc/openvpn/pem.py
RUN /etc/openvpn/createCert.sh

CMD ["bash", "/etc/openvpn/init.sh"]
