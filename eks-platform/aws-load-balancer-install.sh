#!/bin/bash

#Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf.
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.14.1/docs/install/iam_policy.json

#Create an IAM policy using the policy downloaded in the previous step.
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

#Delete Broken eksctl IAM ServiceAccount
eksctl delete iamserviceaccount \
  --cluster=dev-eks-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller

sleep 20

#Verify Service Account(SA)
eksctl get iamserviceaccount \
  --cluster dev-eks-cluster

#Replace the values for cluster name, region code, and account ID.
eksctl create iamserviceaccount \
    --cluster=dev-eks-cluster \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --role-name AmazonEKSLoadBalancerControllerRole \
    --attach-policy-arn=arn:aws:iam::465362303741:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region ap-south-1 \
    --approve

#Add the eks-charts Helm chart repository
helm repo add eks https://aws.github.io/eks-charts

#Update your local repo to make sure that you have the most recent charts.
helm repo update eks

sleep 20

#Install the AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=dev-eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.14.0

#Verify that the AWS LOAD Balancer controller is installed
kubectl get deployment -n kube-system aws-load-balancer-controller
