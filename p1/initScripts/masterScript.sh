#! /bin/sh
yum update -y
yum install -y telnet
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=" --write-kubeconfig-mode 644 server --flannel-iface=eth1" sh -
# cp /var/lib/rancher/k3s/server/node-token /some/synced/path
# cp /etc/rancher/k3s/k3s.yaml /some/synced/path