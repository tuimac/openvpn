FROM alpine:latest

RUN apk add openvpn bash easy-rsa
ADD scripts/init_env.sh /etc/openvpn/init_env.sh
ADD scripts/init_certs.sh /etc/openvpn/init_certs.sh
ADD scripts/createClientConf.sh /etc/openvpn/createClientConf.sh
RUN /etc/openvpn/init_env.sh && \
    /etc/openvpn/init_certs.sh && \
    /etc/openvpn/createClientConf.sh

ENTRYPOINT ['openvpn', '--config'. '/etc/openvpn/server.conf']
