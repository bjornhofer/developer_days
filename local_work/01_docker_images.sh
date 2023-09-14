#!/bin/bash
# Get Repo and start docker compose
cd /home/azuser/git
git clone https://github.com/Azure-Samples/azure-voting-app-redis.git

cd azure-voting-app-redis

docker compose up -d

read -p "Press any key to continue... " -n1 -s
clear

# Login to Azure and Container Registry
/home/azuser/logins/login-msdn.sh
az acr login --name auvadevloperdays
clear

# Show docker images
docker images

read -p "Press any key to continue... " -n1 -s

# Change tag to ACR
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 auvadevloperdays.azurecr.io/azure-vote-front:v1

# Show docker images with changed tags
docker images

read -p "Press any key to continue... " -n1 -s

# Push to ACR
docker push auvadevloperdays.azurecr.io/azure-vote-front:v1

