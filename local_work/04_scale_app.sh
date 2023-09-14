#!/bin/bash

# Login to Azure and Kubernetes
/home/azuser/logins/login-msdn.sh
az aks get-credentials --resource-group AUVA --name auvadevloperdays
clear

kubectl get pods

read -p "Press any key to continue... " -n1 -s

kubectl scale --replicas=5 deployment/azure-vote-front

kubectl get pods