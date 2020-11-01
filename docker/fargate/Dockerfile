FROM alpine:latest

EXPOSE 1194

RUN apk add openvpn bash easy-rsa
ADD init.sh /etc/openvpn/init.sh

CMD ["bash", "/etc/openvpn/init.sh"]
