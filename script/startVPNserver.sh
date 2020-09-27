#!/bin/bash

openvpn --config /etc/openvpn/server.conf --status /etc/openvpn/openvpn-server/status.log --status-version 2 --suppress-timestamps --cipher AES-256-GCM --ncp-ciphers AES-256-GCM:AES-128-GCM:AES-256-CBC:AES-128-CBC:BF-CBC
