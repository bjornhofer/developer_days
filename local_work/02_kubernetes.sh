#!/bin/bash

# Login to Azure and Kubernetes
/home/azuser/logins/login-msdn.sh
az aks get-credentials --resource-group AUVA --name auvadevloperdays
clear

# Show kubernetes nodes
kubectl get nodes