#!/bin/bash

eksctl delete addon \
  --cluster dev-eks-cluster \
  --name aws-ebs-csi-driver

sleep 20
eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster dev-eks-cluster \
  --force

#aws eks create-addon --cluster-name dev-eks-cluster  --addon-name aws-ebs-csi-driver
#aws eks delete-addon --cluster-name dev-eks-cluster --addon-name aws-ebs-csi-driver

#Status checking
kubectl get pods -n kube-system | grep ebs

#Remove default from gp2
#kubectl patch storageclass gp2 \
#  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

#Make gp3 Default (Recommended)
#kubectl patch storageclass gp3 \
#  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
