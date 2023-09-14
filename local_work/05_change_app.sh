#!/bin/bash

# Login to Azure, Kubernetes and ACR
/home/azuser/logins/login-msdn.sh
az aks get-credentials --resource-group AUVA --name auvadevloperdays
az acr login --name auvadevloperdays
clear

vi /home/azuser/git/azure-voting-app-redis/azure-vote/azure-vote/config_file.cfg
read -p "Press any key to continue... " -n1 -s

cd /home/azuser/git/azure-voting-app-redis/
docker compose up --build -d

docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 auvadevloperdays.azurecr.io/azure-vote-front:v2
docker push auvadevloperdays.azurecr.io/azure-vote-front:v2

read -p "Press any key to continue... " -n1 -s

kubectl set image deployment azure-vote-front azure-vote-front=auvadevloperdays.azurecr.io/azure-vote-front:v2

watch -n 1 kubectl get pods
