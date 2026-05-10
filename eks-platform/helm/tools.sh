#!/bin/bash
#
helm repo add prometheus-community \
https://prometheus-community.github.io/helm-charts

helm repo update

helm install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring

kubectl get pods -n monitoring

###############
#
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace sonarqube
helm install sonarqube sonarqube/sonarqube \
-n sonarqube


#########
#
kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl get pods -n argocd
