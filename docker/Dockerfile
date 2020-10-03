FROM centos:latest

WORKDIR /root

ADD env/vimrc /etc/vimrc
ADD env/bashrc /root/.bashrc
ADD env/centos/vim.sh /etc/profile.d/vim.sh

RUN yum update -y && \
    yum install -y iproute curl unzip tcpdump net-tools git tree bind-utils traceroute epel-release python3 vim* && \
    mkdir -p /etc/vim/undo && \
    mkdir -p /etc/vim/backup && \
    rm -rf anaconda-ks.cfg anaconda-post.log original-ks.cfg && \
    yum install -y openvpn easy-rsa && \
    git clone https://github.com/tuimac/openvpn.git && \
    mkdir /dev/net && \
    mknod /dev/net/tun c 10 200

WORKDIR /root/openvpn
