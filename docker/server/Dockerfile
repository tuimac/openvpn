FROM alpine:latest

RUN apk add openvpn
ADD init_env.sh /etc/openvpn/init_env.sh
ADD init_certs.sh /etc/openvpn/init_certs.sh
ADD createClientConf.sh /etc/openvpn/createClientConf.sh
#RUN /etc/openvpn/init_env.sh
WORKDIR /etc/openvpn

#ENTRYPOINT ['openvpn', '--config'. '/etc/openvpn/server.conf']
