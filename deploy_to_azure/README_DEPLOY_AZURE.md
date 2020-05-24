# Primero crear cuenta de azure, descargar kubectl y az
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest

# Login
az login

# Crear grupo de recursos (elijo esa localización pero se puede escoger otras)
az group create --name thechatthatrocks_dev --location eastus

# Crear contenedor para imagenes
az acr create --resource-group thechatthatrocks_dev --name thechatthatrocksacr --sku Basic

# Obtiene el nombre del acr register, en este caso: thechatthatrocksacr.azurecr.io
az acr list --resource-group thechatthatrocks_dev --query "[].{acrLoginServer:loginServer}" --output table

# Login acr
az acr login --name thechatthatrocksacr

# Mediante el docker compose crear imagenes
No recuerdo el comando

# Hace tag de todas las imágenes
docker tag prometheus thechatthatrocksacr.azurecr.io/prometheus:v1

docker tag backend-api thechatthatrocksacr.azurecr.io/backend-api:v1

docker tag encryption thechatthatrocksacr.azurecr.io/encryption:v1

docker tag rabbitmq:latest thechatthatrocksacr.azurecr.io/rabbitmq:v1

docker tag grafana/grafana:7.0.0-beta3 thechatthatrocksacr.azurecr.io/grafana:v1

docker tag postgres:12.2 thechatthatrocksacr.azurecr.io/postgres:v1

docker tag mongo:4.2.5 thechatthatrocksacr.azurecr.io/mongo:v1

# Hacer push de todas las imagenes
docker push thechatthatrocksacr.azurecr.io/prometheus:v1

docker push thechatthatrocksacr.azurecr.io/backend-api:v1

docker push thechatthatrocksacr.azurecr.io/encryption:v1

docker push thechatthatrocksacr.azurecr.io/rabbitmq:v1

docker push thechatthatrocksacr.azurecr.io/grafana:v1

docker push thechatthatrocksacr.azurecr.io/postgres:v1

docker push thechatthatrocksacr.azurecr.io/mongo:v1

# Comprobar que todos estan subidos
az acr repository list --name thechatthatrocksacr --output table

# Create kubernetes cluster
az aks create --resource-group thechatthatrocks_dev --name thechatthatrocksackclusterdev --node-count 2 --attach-acr thechatthatrocksacr --enable-managed-identity

# Obtain cluster credentials
az aks get-credentials --resource-group thechatthatrocks_dev --name thechatthatrocksackclusterdev

# Se procede a realizar el deploy con el script de deploy
kubectl apply -f backend-api-deployment.yaml,mongodb-database-service.yaml,backend-api-service.yaml,backend-api-service-load-balancer.yaml,postgresql-database-deployment.yaml,postgresql-database-service.yaml,encryption-deployment.yaml,prometheus-metrics-deployment.yaml,encryption-service.yaml,prometheus-metrics-service.yaml,grafana-dashboard-deployment.yaml,rabbitmq-broker-deployment.yaml,grafana-dashboard-service.yaml,rabbitmq-broker-service.yaml,mongodb-database-deployment.yaml,grafana-dashboard-load-balancer-service.yaml

# Se comprueba si los servicios están ya activos
kubectl get service grafana-dashboard-load-balancer --watch
kubectl get service backend-api-service-load-balancer --watch

##################
##################
##################

# Una vez que hemos terminado, se paran los servicios y los deployments
kubectl delete deployments --all
kubectl delete services --all

# Se elimina el cluster
az aks delete --resource-group thechatthatrocks_dev --name thechatthatrocksackclusterdev

# El resto de recursos es mejor eliminarlos desde la interfaz web


