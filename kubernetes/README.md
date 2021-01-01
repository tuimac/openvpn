# OpenVPN on Kubernetes

These manifests are to create OpenVPN Pods and Persistent Volume.
This description is for easy deployment explanation.

## How to use

### Prerequisite
Before you launch this OpenVPN container, you need to configure environment variables for the Pods.
There are the sections to configure these environment variables on Deployment manifets `openvpn-deployment.yaml`.
All the env you need to change are below. The Value section is just an explanation.

| Key | Value |
| ----- | ----- |
| CLIENTCERTNAME | Client certification name. |
| EXTERNALPORT | The host port you deploy this OpenVPN container. |
| INTERNALPORT | The container port you deploy this OpenVPN container. |
| PUBLICIIP | You can choose host public IP or public domain name. |
| TUNNELNETWORK | IP range of tunnel network between the client and OpenVPN container.(server in server.conf) |
| ROUTING[number] | IP range of private network you want to connect from client network.(push "route" in server.conf) |

Example is [here](https://github.com/tuimac/openvpn/blob/master/kubernetes/openvpn-deployment.yaml).

### Deployment
First things first, you clone this project.

```
git clone https://github.com/tuimac/openvpn.git
cd kubernetes
```

When you deploy on the Kubernetes network with Flannel, you create a manifest like [this](https://github.com/tuimac/openvpn/blob/master/kubernetes/openvpn-deployment.yaml) to execute the command below.
Before applying these, you need to create a persistent volumes directory. For example in this manifest, you have to create
by `mkdir -p /kubernetes/openvpn`.
```
kubectl apply -f openvpn-volume.yaml
kubectl apply -f openvpn-deployment.yaml
```
