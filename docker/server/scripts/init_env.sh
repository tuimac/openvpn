#!/bin/bash

VIRTUALNETWORK='10.100.100.0/24'
VIRTUALNETWORKCONF='10.100.100.0 255.255.255.0'
ROUTING=('10.3.0.0 255.255.0.0')
SERVERCONF='/etc/openvpn/server.conf'

function serverConfig(){
    echo 'port 1194
proto udp
dev tun
ca /usr/share/easy-rsa/3/pki/ca.crt
cert /usr/share/easy-rsa/3/pki/issued/server.crt
key /usr/share/easy-rsa/3/pki/private/server.key
dh /usr/share/easy-rsa/3/pki/dh.pem
keepalive 10 120
tls-auth /etc/openvpn/ta.key 0 # This file is secret
cipher AES-256-CBC
comp-lzo
max-clients 1
user nobody
group nobody
persist-key
persist-tun
status /var/log/openvpn-status.log
log         /var/log/openvpn.log
log-append  /var/log/openvpn.log
verb 4
explicit-exit-notify 1' > $SERVERCONF
    echo 'server '${VIRTUALNETWORKCONF} >> $SERVERCONF
    for((i=0; i < ${#ROUTING[@]}; i++)); do
        echo 'push "'${ROUTING[$i]}'"' >> $SERVERCONF
    done
}

function network(){
    mkdir /dev/net
    mknod /dev/net/tun c 10 200
    which iptables
    [[ $? -ne 0 ]] && { apk add iptables; }
    iptables -t nat -A POSTROUTING -s $VIRTUALNETWORK -o tun0 -j MASQUERADE
}

function main(){
    #network
    serverConfig
}

main
