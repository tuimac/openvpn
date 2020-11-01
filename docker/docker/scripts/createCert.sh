#!/bin/bash

EASYRSA='/usr/share/easy-rsa/'

cd $EASYRSA
./easyrsa init-pki
./easyrsa --batch build-ca nopass
./easyrsa gen-dh
openvpn --genkey --secret /etc/openvpn/ta.key
./easyrsa build-server-full server nopass
./easyrsa build-client-full tuimac nopass
