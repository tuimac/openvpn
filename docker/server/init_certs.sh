#!/bin/bash

EASYRSA='/usr/share/easy-rsa/3'

cd $EASYRSA
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-dh
openvpn --genkey --secret /etc/openvpn/ta.key
./easyrsa build-server-full server nopass
./easyrsa build-client-full node3 nopass
