#!/bin/bash

VOLUME='ovpn_data'
EXTERNALIP=`hostname -I | awk '{print $1}'`
CLIENTNMAE='test'
SERVERNAME='test'
NAME='openvpn'

function create(){
    docker volume create --name $VOLUME
    docker run --rm \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn:2.3 \
        ovpn_genconfig -u udp://$EXTERNALIP
    docker stop ${NAME}

    docker run --rm -it \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn:2.3 \
        ovpn_initpki
    docker stop ${NAME}

    docker run --rm -it \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn:2.3 \
        easyrsa build-server-full ${SERVERNAME} nopass
    docker stop ${NAME}

    docker run --rm -it \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn:2.3 \
        easyrsa build-client-full ${CLIENTNAME} nopass
    docker stop ${NAME}

    docker run --rm \
        -v $VOLUME:/etc/openvpn \
        --log-driver=none \
        --name ${NAME} \
        kylemanna/openvpn:2.3 \
        ovpn_getclient ${CLIENTNAME} > ${CLIENTNAME}.ovpn
    docker stop ${NAME}
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
