FROM alpine:latest

RUN apk add openvpn bash easy-rsa
ADD scripts/init.sh /etc/openvpn/init.sh
ADD scripts/createCert.sh /etc/openvpn/createCert.sh
RUN /etc/openvpn/createCert.sh

CMD ["bash", "/etc/openvpn/init.sh"]
# include createCert into CMD
# when finish to create certification, send email with certs
