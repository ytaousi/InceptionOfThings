#!/bin/sh

k3d cluster create test --no-lb --k3s-arg="--disable=traefik@server:0"

kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab

kubectl apply -f /home/normal-user/Desktop/InceptionOfThings/bonus/confs/traefik.yaml -n kube-system

kubectl wait -n kube-system --for=condition=available deployment --all --timeout=5m

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait -n argocd --for=condition=available deployment --all --timeout=5m

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab -n gitlab \
    --set global.edition=ce \
    --set global.hosts.domain=localgitlab \
    --set global.hosts.https="false" \
    --set global.ingress.configureCertmanager="false" \
    --set certmanager-issuer.email=yassir.taous@gmail.com \
    --set gitlab-runner.install="false" 

kubectl wait -n gitlab --for=condition=available deployment --all --timeout=5m

cat <<EOF | kubectl -n gitlab apply -f -
apiVersion: v1
kind: Service
metadata:
  name: gitlab-svc
  namespace: gitlab
spec:
  type: LoadBalancer
  selector:
    app.kubernetes.io/name: gitlab-webservice-default
  ports:
  - port: 8085
    protocol: TCP
    targetPort: 8085
EOF

# kubectl port-forward --address 0.0.0.0 svc/gitlab-webservice-default -n gitlab 8085:8181 
# kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443 