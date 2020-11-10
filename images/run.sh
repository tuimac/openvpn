#!/bin/bash

# Change variables below if you need
##############################
NAME="openvpn"
VOLUME="${PWD}/volume"
DOCKERHUBUSER=""
CPUARCH="x64"
##############################

function runContainer(){
    docker volume create ${NAME}
    docker run -itd --name ${NAME} \
        -v ${VOLUME}:/tmp \
        -v ${NAME}:/etc/openvpn \
        -p 30001:1194/udp \
        -p 30001:1194/tcp \
        --cap-add NET_ADMIN \
        --env-file env.list \
        --network=bridge \
        -h ${NAME} \
        ${NAME}
}

function cleanup(){
    docker image prune -f
    docker container prune -f
}

function createContainer(){
    mkdir ${VOLUME}
    docker build -t ${NAME} -f Dockerfile-${CPUARCH} .
    runContainer
    cleanup
}

function rerunContainer(){
    echo -en "Do you want to commit image? [y(default)/n]: "
    read answer
    if [ "$answer" != "n" ]; then
        commitImage ${NAME}
    fi
    docker stop ${NAME}
    docker rm ${NAME}
    runContainer
    cleanup
}

function deleteAll(){
    docker stop ${NAME}
    docker rm ${NAME}
    docker rmi ${NAME}
    docker volume rm ${NAME}
    cleanup
    sudo rm -rf ${VOLUME}
}

function commitImage(){
    docker stop ${NAME}
    docker commit ${NAME} $1
    docker start ${NAME}
}


function userguide(){
    echo -e "usage: ./run.sh [help | create | delete | commit | register-secret]"
    echo -e "
optional arguments:
create              Create image and container after that run the container.
rerun               Delete only container and rerun container with new settings.
delete              Delete image and container.
commit              Create image from target container and push the image to remote repository.
    "
}

function main(){
    [[ -z $1 ]] && { userguide; exit 1; }
    if [ $1 == "create" ]; then
        createContainer
    elif [ $1 == "rerun" ]; then
        rerunContainer
    elif [ $1 == "delete" ]; then
        deleteAll
    elif [ $1 == "commit" ]; then
        commitImage ${NAME}
    elif [ $1 == "help" ]; then
        userguide
    else
        { userguide; exit 1; }
    fi
}

main $1
