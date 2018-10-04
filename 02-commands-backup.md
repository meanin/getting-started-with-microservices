## Create a resource group
az group create --name getting-started-with-microservices-backup --location westeurope

## Create a container registry
az acr create --resource-group getting-started-with-microservices-backup --name gettingstartedregistrybackup --sku Basic

## Log into the registry
az acr login --name gettingstartedregistrybackup

## Build a docker image
docker build -f ScaffoldedWebApi\Dockerfile -t "getting-started-app:latest" .

## Tag the docker image with a registry domain
docker tag getting-started-app:latest gettingstartedregistrybackup.azurecr.io/getting-started-app:latest

## Push an image into registry
docker push gettingstartedregistrybackup.azurecr.io/getting-started-app:latest

## Create an Azure container instance
az acr update -n gettingstartedregistrybackup --admin-enabled true

az acr credential show --name gettingstartedregistrybackup --query "passwords[0].value"

az container create --resource-group getting-started-with-microservices-backup --name gettingstartedinstancebackup --image gettingstartedregistrybackup.azurecr.io/getting-started-app:latest --registry-username gettingstartedregistrybackup --registry-password <acrPassword> --dns-name-label getting-started-instace-backup --ports 80

http://getting-started-instace-backup.westeurope.azurecontainer.io/api/helloworld

## Create Service Principal for role base access 
az ad sp create-for-rbac --skip-assignment

## Connect RBAC with Registry
az acr show --resource-group getting-started-with-microservices-backup --name gettingstartedregistrybackup --query "id" --output tsv

az role assignment create --assignee <appId> --scope <acrId> --role Reader

## Create Azure Kubernetes Service
az aks create --resource-group getting-started-with-microservices-backup --name ak8sbackup --node-count 1 --service-principal <appId> --client-secret <password> --generate-ssh-keys

## Connecting to the AKS clustes
az aks get-credentials --resource-group getting-started-with-microservices-backup --name ak8sbackup

kubectl get nodes

## Kubectl commands
kubectl apply -f kubernetes\backup.deployment.yaml
kubectl get deployments
kubectl apply -f kubernetes\backup.service.yaml
kubectl get svc -w
kubectl scale deployment scaffolded-deployment --replicas=2
kubectl delete deployment scaffolded-deployment
kubectl apply -f kubernetes\backup.statefulset.yaml
kubectl scale statefulset scaffolded-statefulset --replicas=2

#### Navigation:

0. [Readme](README.md)
1. [Prerequisites](10-getting-started-prerequisites.md)
2. [Docker](20-getting-started-docker.md)
3. [Kubernetes](30-getting-started-kubernetes.md)
10. [Commands](01-commands.md)