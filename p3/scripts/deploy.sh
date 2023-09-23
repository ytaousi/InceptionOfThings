#!/bin/bash


###                             ###
## Don't Start this file at once ##
###                             ###
k3d cluster create test --no-lb --k3s-arg="--disable=traefik@server:0"

kubectl create namespace argocd
kubectl create namespace dev


kubectl apply -f /home/normal-user/Desktop/42-projects/InceptionOfThings/p3/confs/traefik.yaml -n kube-system
# we should wait until treafik pods are ready then we can go further into the deployment


kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 
# we should wait until argocd pod is ready then ask for the password of the admin user





kubectl apply -f /home/normal-user/Desktop/42-projects/InceptionOfThings/p3/confs/deployments.yaml -n dev
kubectl apply -f /home/normal-user/Desktop/42-projects/InceptionOfThings/p3/confs/services.yaml -n dev
kubectl apply -f /home/normal-user/Desktop/42-projects/InceptionOfThings/p3/confs/traefik-ingress.yaml -n dev

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d

#kubectl -n argocd port-forward svc/argocd-server 8080:443

kubectl apply -n argocd -f /home/normal-user/Desktop/42-projects/InceptionOfThings/p3/confs/application.yaml
