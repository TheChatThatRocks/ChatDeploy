## Introduction
Deploy instructions of the project  

### Requirements
You must setup Docker, Docker Compose, Kubernetes and Minikube (optional).
- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Kubernetes](https://kubernetes.io/docs/setup/)
- [Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/)

## Deploy
There are different deploy options. All assume that all repositories of the project are downloaded in the same directory level and their name have not changed.

## Deploy backend in localhost and the other machines in local with Docker Compose
To deploy it, execute the following commands:  
```bash
$ docker-compose -f "ChatDeploy/docker-compose-local-without-backend.yml" up --build
$ # Execute this in a second terminal
$ cd ../ChatBackendAPI
$ ./gradlew bootRun
```

You can stop them with Ctrl-C.  
After stop it, execute the following commands:  
```bash
$ docker image prune
$ docker volume prune
``` 

## Deploy all machines in local with Docker Compose
To deploy it, execute the following command:  
```bash
$ docker-compose -f "ChatDeploy/docker-compose-local.yml" up --build
```

You can stop it with Ctrl-C.  
After stop it, execute the following commands:  
```bash
$ docker image prune
$ docker volume prune
``` 

## Deploy all machines in Minikube with Kubernetes
To deploy it, execute the following commands (It is assumed that Minikube is already running):
```bash
# Build all images
$ docker-compose -f docker-compose-local.yml build

# Tag all images
$ docker tag prometheus thechatthatrocksacr.azurecr.io/prometheus:v1
$ docker tag backend-api thechatthatrocksacr.azurecr.io/backend-api:v4
$ docker tag encryption thechatthatrocksacr.azurecr.io/encryption:v1
$ docker tag rabbitmq:latest thechatthatrocksacr.azurecr.io/rabbitmq:v1
$ docker tag grafana:latest thechatthatrocksacr.azurecr.io/grafana:v2
$ docker tag postgres:12.2 thechatthatrocksacr.azurecr.io/postgres:v1
$ docker tag mongo:4.2.5 thechatthatrocksacr.azurecr.io/mongo:v1

# Deploy all images
$ cd kubernetes_deploy
$ kubectl apply -f backend-api-deployment.yaml,mongodb-database-service.yaml,backend-api-service.yaml,backend-api-service-load-balancer.yaml,postgresql-database-deployment.yaml,postgresql-database-service.yaml,encryption-deployment.yaml,prometheus-metrics-deployment.yaml,encryption-service.yaml,prometheus-metrics-service.yaml,grafana-dashboard-deployment.yaml,rabbitmq-broker-deployment.yaml,grafana-dashboard-service.yaml,rabbitmq-broker-service.yaml,mongodb-database-deployment.yaml,grafana-dashboard-load-balancer-service.yaml
```

In order to check if the services are available, use the following commands:
```bash
$ kubectl get service grafana-dashboard-load-balancer --watch
$ kubectl get service backend-api-service-load-balancer --watch
```

To stop it, execute the following commands:  
```bash
$ kubectl delete deployments --all
$ kubectl delete services --all
```

## Deploy all machines in Azure with Kubernetes
First of all, you have to create the images and tag them with the following commands:
```bash
# Build all images
$ docker-compose -f docker-compose-local.yml build

# Tag all images
$ docker tag prometheus thechatthatrocksacr.azurecr.io/prometheus:v1
$ docker tag backend-api thechatthatrocksacr.azurecr.io/backend-api:v4
$ docker tag encryption thechatthatrocksacr.azurecr.io/encryption:v1
$ docker tag rabbitmq:latest thechatthatrocksacr.azurecr.io/rabbitmq:v1
$ docker tag grafana:latest thechatthatrocksacr.azurecr.io/grafana:v2
$ docker tag postgres:12.2 thechatthatrocksacr.azurecr.io/postgres:v1
$ docker tag mongo:4.2.5 thechatthatrocksacr.azurecr.io/mongo:v1
```

Secondly, you have to create the Azure resources.
To do that, execute the following commands (It is assumed that you are already logged in with Azure CLI):
```bash
# Create resource group called thechatthatrocks_dev in East US
$ az group create --name thechatthatrocks_dev --location eastus

# Create a container image register with name thechatthatrocksacr and Basic plan
$ az acr create --resource-group thechatthatrocks_dev --name thechatthatrocksacr --sku Basic

# Obtain the container image register name. From now on, I assume that it is called thechatthatrocksacr.azurecr.io
$ az acr list --resource-group thechatthatrocks_dev --query "[].{acrLoginServer:loginServer}" --output table

# Create Kubernetes cluster with 2 nodes
$ az aks create --resource-group thechatthatrocks_dev --name thechatthatrocksackclusterdev --node-count 2 --attach-acr thechatthatrocksacr --enable-managed-identity

# Obtain cluster credentials
$ az aks get-credentials --resource-group thechatthatrocks_dev --name thechatthatrocksackclusterdev
```

Next, you have to upload the images to the container image register executing the following commands:
```bash
# Login acr
$ az acr login --name thechatthatrocksacr

# Push all mages
$ docker push thechatthatrocksacr.azurecr.io/prometheus:v1
$ docker push thechatthatrocksacr.azurecr.io/backend-api:v4
$ docker push thechatthatrocksacr.azurecr.io/encryption:v1
$ docker push thechatthatrocksacr.azurecr.io/rabbitmq:v1
$ docker push thechatthatrocksacr.azurecr.io/grafana:v2
$ docker push thechatthatrocksacr.azurecr.io/postgres:v1
$ docker push thechatthatrocksacr.azurecr.io/mongo:v1

# Check if images have been uploaded
$ az acr repository list --name thechatthatrocksacr --output table
```

Finally, you can deploy your images using the following command:
```bash
# Deploy all images
$ cd kubernetes_deploy
$ kubectl apply -f backend-api-deployment.yaml,mongodb-database-service.yaml,backend-api-service.yaml,backend-api-service-load-balancer.yaml,postgresql-database-deployment.yaml,postgresql-database-service.yaml,encryption-deployment.yaml,prometheus-metrics-deployment.yaml,encryption-service.yaml,prometheus-metrics-service.yaml,grafana-dashboard-deployment.yaml,rabbitmq-broker-deployment.yaml,grafana-dashboard-service.yaml,rabbitmq-broker-service.yaml,mongodb-database-deployment.yaml,grafana-dashboard-load-balancer-service.yaml
```

In order to check if the services are available, use the following commands (there you can obtain the IP address of them):
```bash
$ kubectl get service grafana-dashboard-load-balancer --watch
$ kubectl get service backend-api-service-load-balancer --watch
```

To stop it, execute the following commands:  
```bash
$ kubectl delete deployments --all
$ kubectl delete services --all
```

If you want to delete all Azure resources execute the following commands:
```bash
$ az group delete --name thechatthatrocks_dev --yes
$ az group delete --name NetworkWatcherRG --yes
```