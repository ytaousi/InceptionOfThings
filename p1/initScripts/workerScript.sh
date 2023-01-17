#! /bin/sh
apt-get update
apt-get upgrade -y
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-iface=eth1" K3S_TOKEN=$(cat /vagrantShared/node-token) K3S_URL=https://192.168.56.110:6443 sh -