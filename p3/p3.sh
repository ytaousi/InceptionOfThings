#!/bin/bash

sudo apt update
sudo apt upgrade -y
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

k3d cluster create test --no-lb --k3s-arg="--disable=traefik@server:0"

kubectl create namespace argocd
kubectl create namespace dev


kubectl apply -f /home/normal-user/Desktop/iot/traefik.yaml -n kube-system
kubectl apply -f /home/normal-user/Desktop/iot/deployments.yaml -n dev
kubectl apply -f /home/normal-user/Desktop/iot/services.yaml -n dev
kubectl apply -f /home/normal-user/Desktop/iot/traefik-ingress.yaml -n dev


kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d