#!/bin/bash

CLIENTNAME='test'
OVPN=${CLIENTNAME}'.ovpn'

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
cat /usr/share/easy-rsa/3/pki/ca.crt >> $OVPN
echo '</ca>' >> $OVPN

echo '<key>' >> $OVPN
cat /usr/share/easy-rsa/3/pki/private/${CLIENTNAME}.key >> $OVPN
echo '</key>' >> $OVPN

echo '<cert>' >> $OVPN
cat /usr/share/easy-rsa/3/pki/issued/${CLIENTNAME}.crt >> $OVPN
echo '</cert>' >> $OVPN

echo '<tls-auth>' >> $OVPN
cat /etc/openvpn/ta.key >> $OVPN
echo '</tls-auth>' >> $OVPN
