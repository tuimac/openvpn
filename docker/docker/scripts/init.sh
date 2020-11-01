#!/bin/bash

CLIENTCERTNAME='tuimac'
CLIENTCERTPATH='/etc/openvpn/'${CLIENTCERTNAME}'.ovpn'
EASYRSA='/usr/share/easy-rsa'
EXTERNALPORT=30000
INTERNALPORT=1194
VIRTUALNETWORK='10.150.100.0/24'
ROUTINGS=('10.3.0.0/16')
SERVERCONF='/etc/openvpn/server.conf'

function convertNetmask(){
    local network=${1}
    local index=0
    RESULT=''

    for x in ${network//// }; do
        [[ $index -eq 0 ]] && { RESULT=$x' '; }
        [[ $index -eq 1 ]] && { SUBNET=$x; }
        ((index++))
    done
    local subnetmask=''
    for((i=0; i < $((SUBNET / 8)); i++)); do
        subnetmask+='255.'
    done
    subnetmask+=$((256 - ( 1 << (8 - (SUBNET % 8)))))
    for((i=0; i < $((3 - (SUBNET / 8))); i++)); do
        subnetmask=${subnetmask}'.0'
    done
    RESULT+=$subnetmask
}

function createClientCert(){
    cat <<EOF > $CLIENTCERTPATH
client
dev tun
proto udp
remote vpn-public $PORT
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
EOF

    echo '<ca>' >> $CLIENTCERTPATH
    cat ${EASYRSA}/pki/ca.crt >> $CLIENTCERTPATH
    echo '</ca>' >> $CLIENTCERTPATH

    echo '<key>' >> $CLIENTCERTPATH
    cat ${EASYRSA}/pki/private/${CLIENTCERTNAME}.key >> $CLIENTCERTPATH
    echo '</key>' >> $CLIENTCERTPATH

    echo '<cert>' >> $CLIENTCERTPATH
    cat ${EASYRSA}/pki/issued/${CLIENTCERTNAME}.crt >> $CLIENTCERTPATH
    echo '</cert>' >> $CLIENTCERTPATH

    echo '<tls-auth>' >> $CLIENTCERTPATH
    cat /etc/openvpn/ta.key >> $CLIENTCERTPATH
    echo '</tls-auth>' >> $CLIENTCERTPATH
}

function downloadPem(){
    python3 /etc/openvpn/pem.py $CLIENTCERTPATH $INTERNALPORT
}

function serverConfig(){
    cat <<EOF > $SERVERCONF
port ${INTERNALPORT}
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
explicit-exit-notify 1
EOF
    convertNetmask $VIRTUALNETWORK
    echo 'server '${RESULT} >> $SERVERCONF
    for((i=0; i < ${#ROUTINGS[@]}; i++)); do
        convertNetmask ${ROUTINGS[$i]}
        echo 'push "route '${RESULT}'"' >> $SERVERCONF
    done
}

function startVPN(){
    mkdir /dev/net
    mknod /dev/net/tun c 10 200
    iptables -t nat -A POSTROUTING -s $VIRTUALNETWORK -o eth0 -j MASQUERADE
    for route in ${ROUTINGS[@]}; do
        iptables -t nat -A POSTROUTING -s $route -o eth0 -j MASQUERADE
    done
    exec openvpn --config /etc/openvpn/server.conf
}

function main(){
    serverConfig
    createClientCert
    downloadPem
    startVPN
}

main
