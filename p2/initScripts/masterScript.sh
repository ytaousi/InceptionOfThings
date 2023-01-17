#! /bin/sh
apt-get update
apt-get upgrade -y
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=" --write-kubeconfig-mode 644 server --flannel-iface=eth1" sh -