#!/bin/bash

function createClientCert(){
    local clientname='tuimac'
    CLIENTCERT='/etc/openvpn/'${clientname}'.ovpn'
    local easyrsa='/usr/share/easy-rsa'

    echo 'client
dev tun
proto udp
remote vpn-public 30000
resolv-retry infinite
nobind
persist-key
persist-tun
user nobody
group nobody
remote-cert-tls server
tls-client
comp-lzo
cipher AES-256-CBC
verb 4
tun-mtu 1500
key-direction 1
    ' > $CLIENTCERT

    echo '<ca>' >> $CLIENTCERT
    cat ${easyrsa}/pki/ca.crt >> $CLIENTCERT
    echo '</ca>' >> $CLIENTCERT

    echo '<key>' >> $CLIENTCERT
    cat ${easyrsa}/pki/private/${clientname}.key >> $CLIENTCERT
    echo '</key>' >> $CLIENTCERT

    echo '<cert>' >> $CLIENTCERT
    cat ${easyrsa}/pki/issued/${clientname}.crt >> $CLIENTCERT
    echo '</cert>' >> $CLIENTCERT

    echo '<tls-auth>' >> $CLIENTCERT
    cat /etc/openvpn/ta.key >> $CLIENTCERT
    echo '</tls-auth>' >> $CLIENTCERT
}

function serverConfig(){
    local virtualnetworkconf='10.100.100.0 255.255.255.0'
    local routing=('10.3.0.0 255.255.0.0')
    local serverconf='/etc/openvpn/server.conf'
    
    echo 'port 1194
proto udp
dev tun
ca /usr/share/easy-rsa/pki/ca.crt
cert /usr/share/easy-rsa/pki/issued/server.crt
key /usr/share/easy-rsa/pki/private/server.key
dh /usr/share/easy-rsa/pki/dh.pem
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
explicit-exit-notify 1' > $serverconf
    echo 'server '${virtualnetworkconf} >> $serverconf
    for((i=0; i < ${#routing[@]}; i++)); do
        echo 'push "route '${routing[$i]}'"' >> $serverconf
    done
}

function startVPN(){
    local virtualnetwork='10.100.100.0/24'
    
    mkdir /dev/net
    mknod /dev/net/tun c 10 200
    which iptables > /dev/null 2>&1
    [[ $? -ne 0 ]] && { apk add iptables; }
    iptables -t nat -A POSTROUTING -s $virtualnetwork -o tun0 -j MASQUERADE
    exec openvpn --config /etc/openvpn/server.conf
}

function main(){
    serverConfig
    createClientCert
    startVPN
}

main
