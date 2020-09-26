#!/bin/bash

VOLUME='ovpn_data'
EXTERNALIP=`hostname -I | awk '{print $1}'`
CLIENTNMAE='test'
NAME='openvpn'

function create(){
    docker volume create --name $VOLUME
    docker run --rm \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn \
        ovpn_genconfig -u udp://$EXTERNALIP

    docker run --rm -it \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn \
        ovpn_initpki

    docker run -d \
        -v $VOLUME:/etc/openvpn \
        -p 1194:1194/udp \
        --name ${NAME} \
        --cap-add=NET_ADMIN \
        kylemanna/openvpn

    docker run --rm -it \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn \
        easyrsa build-client-full ${CLIENTNAME} nopass

    docker run --rm \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn \
        ovpn_getclient ${CLIENTNAME} > ${CLIENTNAME}.ovpn
}

function delete(){
    docker stop ${NAME}
    docker rm ${NAME}
    docker volume rm ${VOLUME}
}

function main(){

    if [[ $1 == "create" ]]; then
        create
    elif [[ $1 == "delete" ]]; then
        delete
    else
        echo 'Wrong argument!'
        exit 1
    fi
}

main $1
