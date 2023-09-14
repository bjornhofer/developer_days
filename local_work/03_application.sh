#!/bin/bash

# Login to Azure 
/home/azuser/logins/login-msdn.sh
clear

echo "copy the line below and paste it into appropriate place in the file (line 60)"
az acr list --resource-group AUVA --query "[].{acrLoginServer:loginServer}" --output tsv
read -p "Press any key to continue... " -n1 -s

vi /home/azuser/git/azure-voting-app-redis/azure-vote-all-in-one-redis.yaml

clear
read -p "Press any key to continue... " -n1 -s
kubectl apply -f /home/azuser/git/azure-voting-app-redis/azure-vote-all-in-one-redis.yaml


read -p "Wait a few moments for public IP is deployed" -n1 -s
kubectl get service azure-vote-front --watch
