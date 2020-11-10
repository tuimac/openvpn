# OpenVPN on Docker
[dockerhub-x64]: <https://hub.docker.com/r/tuimac/openvpn>
[dockerhub-aarch64]: <https://hub.docker.com/r/tuimac/openvpn-aarch64>
[![Build Status](https://travis-ci.com/tuimac/openvpn.svg?branch=master)](https://travis-ci.com/tuimac/openvpn)

This OpenVPN can be deployed on any docker environment. You can deploy on ECS, Fargate, Kubernetes and so on.
The way of deployment and operation is follow that.

# Run as singie container on Docker Environment
You can deploy a container to do `docker build` and `docker run` from my docker images ([x64][dockerhub-x64], [aarch64][dockerhub-aarch64]).
This image don't have any certifications. When you run docker container from those images, entrypoint execute script `init.sh` to create certifications and run certifications download manager.
These are the steps how to use after you deploy container from tuimac/openvpn.

### Access to server run OpenVPN container through HTTP.
After `init.sh` create certifications, run download manager as http server. If you deploy this container on the server with 192.168.0.10, you can get certification <clinetname>.ovpn like this
```sh
$ curl http://192.168.0.10:30000
```
Once the download manager receive HTTP request, delete <client.ovpn> file in the container and terminate the download manager itself. Sometimes or depends on your server spec, it takes times to generate diffie hellman key. If you couldn't download certification from the server, please check to do `docker logs <containername>`. 

If the output is like below
```sh
$ git clone https://github.com/tuimac/openvpn.git
```

I created the small tool for the manipulation of docker is `run.sh`. 
### Clone repository
First things first, do `git clone`.
```sh
$ git clone https://github.com/tuimac/openvpn.git
```
### Change 
Then change directory to images/ and you can see two Dockerfiles. 
You have to pick one Dockerfile is `Dockerfile-x64` or `Dockerfile-aarch64` depends on cpu architecture you want to run.
