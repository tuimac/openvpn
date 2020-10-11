#!/bin/bash

CLIENTNAME='node3'
OVPN=${CLIENTNAME}'.ovpn'
EASYRSA='/usr/share/easy-rsa'

echo 'client
dev tun
proto udp
remote 0.0.0.0 1194
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
' > $OVPN

echo '<ca>' >> $OVPN
cat ${EASYRSA}/pki/ca.crt >> $OVPN
echo '</ca>' >> $OVPN

echo '<key>' >> $OVPN
cat ${EASYRSA}/pki/private/${CLIENTNAME}.key >> $OVPN
echo '</key>' >> $OVPN

echo '<cert>' >> $OVPN
cat ${EASYRSA}/pki/issued/${CLIENTNAME}.crt >> $OVPN
echo '</cert>' >> $OVPN

echo '<tls-auth>' >> $OVPN
cat /etc/openvpn/ta.key >> $OVPN
echo '</tls-auth>' >> $OVPN
