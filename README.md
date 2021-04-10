# OpenVPN on Docker
[env.list]: <https://github.com/tuimac/openvpn/blob/master/builds/env.list>
[manifests]: <https://github.com/tuimac/openvpn/tree/master/kubernetes>
[![CircleCI](https://circleci.com/gh/tuimac/openvpn.svg?style=shield)](https://circleci.com/gh/tuimac/openvpn)

This OpenVPN can be deployed on any docker environment.
You can deploy on ECS, Fargate, Kubernetes, and so on.
This OpenVPN container support only L3 Tunnel Network.
The way of deployment and operation is to follow that.

# Run as a single container on Docker Environment
You can deploy a container to do `docker build` and `docker run` from my docker images.
This image doesn't have any certifications.
When you run docker container from those images,
entrypoint execute script `entrypoint.sh` to create certifications and run certifications download manager.
These are the steps how to use after you deploy the container from tuimac/openvpn.

## How to use

### Prerequisite
Before you launch this OpenVPN container, you need to configure environment variables for the container.
All the env you need to change are below. The Value section is just an explanation.

| Key | Value |
| ----- | ----- |
| CLIENTCERTNAME | Client certification name. |
| EXTERNALPORT | The host port you deploy this OpenVPN container. |
| INTERNALPORT | The container port you deploy this OpenVPN container. |
| PUBLICIIP | You can choose host public IP or public domain name. |
| TUNNELNETWORK | IP range of tunnel network between the client and OpenVPN container.(server in server.conf) |
| ROUTING[number] | IP range of private network you want to connect from client network.(push "route" in server.conf) |

Example is [here][env.list].

### Deployment
I completed deploying on the docker bridge network and Kubernetes network with Flannel.
(I don't know why I failed to connect to the container on the Calico CNI network....)
Here is an example of deployment on x86 architecture environment.

When you deploy on the docker bridge network, execute the command below.
```
docker volume create openvpn
docker run -itd --name openvpn -v openvpn:/etc/opnevpn -p 30001:1194/udp -p 30001:1194/tcp --cap-add NET_ADMIN --env-file env.list --network bridge tuimac/openvpn
```
I created the small tool for the manipulation of docker is `run.sh`.
This script does building images, creating containers, deleting containers and images, and so on.
So if you want to customize this OpenVPN and debug, you can use that.

When you deploy on the Kubernetes network with Flannel, you create a manifest like [this][manifests] execute the command below.
Before applying these, you need to create a persistent volumes directory. For example in this manifest, you have to create
by `mkdir -p /kubernetes/openvpn`.
```
kubectl apply -f openvpn-volume.yaml
kubectl apply -f openvpn-deployment.yaml
```

### Start to connect
After `entrypoint.sh` create certifications, run download manager as the HTTP server.
If you deploy this container on the server with 192.168.0.10,
you can get certification `<clinetname>.ovpn` like this
```
curl http://192.168.0.10:30000
```
Once the download manager receives HTTP requests,
delete `<clientname>.ovpn` file in the container and terminate the download manager itself.
Sometimes or depends on your server spec, it takes time to generate the Diffie Hellman key.
If you couldn't download certification from the server, please check to do `docker logs <containername>`.

If you don't have any problems, you can connect to OpenVPN.

## OpenVPN High Availability Architechture
If you use this image on the Kubernetes cluster or some other Docker Container cluster environment, you can provide high availability VPN environment. <br>
The picture below explains how to build high availability environment. Shared storage like NFS shares the core files which are configuration files and server certification files. Each pod within the Kubernetes cluster can get the information of that shared storage path if the persistent volume in the deployment manifest point to the host path is mounted by Shared storage.<br>
But you have to consider Shared storage redundancy. If that storage weakens, that will be a single point of failure.

![openvpn-redundancy](https://user-images.githubusercontent.com/18078024/111646279-db1a0000-8844-11eb-8939-c446587a4ca1.png)

## Docker images
I create Docker images for x86 and aarch64 environment [here](https://hub.docker.com/repository/docker/tuimac/openvpn).
I do build image by buildx which is multi platform build tool.([buildx](https://github.com/docker/buildx))

## Authors

* **Kento Kashiwagi** - [tuimac](https://github.com/tuimac)

If you have some opinions and find bugs, please post [here](https://github.com/tuimac/openvpn/issues).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Plan

- Try to deploy on ECS and Fargate cluster.
- Implement management web console to manage Users.
- To test scaling architecture.
