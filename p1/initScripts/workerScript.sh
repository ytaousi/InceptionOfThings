#! /bin/sh
yum update -y
yum install -y telnet
#curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-iface=eth1" K3S_TOKEN=$NODE_TOKEN K3S_URL=$MASTERNODE_URL sh -