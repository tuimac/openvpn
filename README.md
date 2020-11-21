# OpenVPN on Docker
[dockerhub-x64]: <https://hub.docker.com/r/tuimac/openvpn>
[dockerhub-aarch64]: <https://hub.docker.com/r/tuimac/openvpn-aarch64>
[env.list]: <https://github.com/tuimac/openvpn/blob/master/images/env.list>
[manifests]: <https://github.com/tuimac/openvpn/tree/master/kubernetes>
[![Build Status](https://travis-ci.com/tuimac/openvpn.svg?branch=master)](https://travis-ci.com/tuimac/openvpn)

This OpenVPN can be deployed on any docker environment. 
You can deploy on ECS, Fargate, Kubernetes and so on.
This OpenVPN container support only L3 Tunnel Network.
The way of deployment and operation is follow that.

# Run as singie container on Docker Environment
You can deploy a container to do `docker build` and `docker run` from my docker images ([x64][dockerhub-x64], [aarch64][dockerhub-aarch64]).
This image don't have any certifications. 
When you run docker container from those images, 
entrypoint execute script `init.sh` to create certifications and run certifications download manager.
These are the steps how to use after you deploy container from tuimac/openvpn.

## How to use

### Prerequisite
Before you launch this OpenVPN container, you need to configure enviroment variables for thie container.
All the env you need to change are below. Value section is just explanation.

| Key | Value |
| ----- | ----- |
| CLIENTCERTNAME | Client certification name. |
| EXTERNALPORT | The host port you deploy this OpenVPN container. |
| INTERNALPORT | The container port you deploy this OpenVPN container. |
| PUBLICIIP | You can choose host public ip or public domain name. |
| TUNNELNETWORK | IP range of tunnel network between client and OpenVPN container.(server in server.conf) |
| ROUTING[number] | IP range of private network you want to connect from client network.(push "route" in server.conf) |

Example is [here][env.list].

### Deployment
I completed to deploy on docker bridge network and kubernetes network with Flannel.
(I don't know why I failed to connect to container on Calico CNI network....)
Here is example of deployment on x86 architechture environment. 

When you deploy on docker bridge network, execute command below.
```
docker volume create openvpn
docker run -itd -v openvpn:/etc/opnevpn -p 30001:1194/udp -v 30001:1194/tcp --cap-add NET_ADMIN --env-file env.list --network bridge tuimac/openvpn
```

When you deploy on kubernetes network with Flannel, you create manifest like [this][manifests] execute command below.
```
kubectl apply -f openvpn-volume.yaml
kubectl apply -f openvpn-deployment.yaml
```

### Access to server run OpenVPN container through HTTP.
After `init.sh` create certifications, run download manager as http server. If you deploy this container on the server with 192.168.0.10, you can get certification <clinetname>.ovpn like this
```
curl http://192.168.0.10:30000
```
Once the download manager receive HTTP request, delete [clientname].ovpn file in the container and terminate the download manager itself. Sometimes or depends on your server spec, it takes times to generate diffie hellman key. If you couldn't download certification from the server, please check to do `docker logs <containername>`. 

If the output is like below
```
git clone https://github.com/tuimac/openvpn.git
```

I created the small tool for the manipulation of docker is `run.sh`. 


### Clone repository
First things first, do `git clone`.
```
git clone https://github.com/tuimac/openvpn.git
```
### Change
Then change directory to images/ and you can see two Dockerfiles. 
You have to pick one Dockerfile is `Dockerfile-x64` or `Dockerfile-aarch64` depends on cpu architecture you want to run.
