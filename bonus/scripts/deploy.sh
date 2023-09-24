#!/bin/bash


kubectl apply -f /home/normal-user/Desktop/InceptionOfThings/bonus/confs/deployments.yaml -n dev
kubectl apply -f /home/normal-user/Desktop/InceptionOfThings/bonus/confs/services.yaml -n dev
kubectl apply -f /home/normal-user/Desktop/InceptionOfThings/bonus/confs/traefik-ingress.yaml -n dev
kubectl apply -n argocd -f /home/normal-user/Desktop/InceptionOfThings/bonus/confs/application.yaml

# kubectl port-forward --address 0.0.0.0 svc/gitlab-webservice-default -n gitlab 8085:8181
# kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443

echo -en "\n\033[32m##### deployments finished #####\033[0m\n\n"
echo
echo "will application:"
echo "app.local:8888"
echo
echo "--------------------"
echo
echo "argocd application:"
echo "argocd.local:8080"
echo
echo "argocd-user:"
echo "admin"
echo
echo "argocd-password:"
echo $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo)
echo
echo "--------------------"
echo
echo "gitlab application:"
echo "gitlab.local:8085"
echo
echo "gitlab-user:"
echo "root"
echo
echo "gitlab-password:"
echo $(kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 -d; echo)
echo