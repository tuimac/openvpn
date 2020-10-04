#!/bin/bash

python3 initOpenVPN.py
tree /usr/share/easy-rsa/3/pki
rm -rf /usr/share/easy-rsa/3/pki
