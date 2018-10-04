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

az role assignment create --assignee d151991c-0676-4878-9985-3b00f562c6b3 --scope /subscriptions/8d72ff15-350d-47c0-b248-319580724285/resourceGroups/getting-started-with-microservices-backup/providers/Microsoft.ContainerRegistry/registries/gettingstartedregistrybackup --role Reader

## Create Azure Kubernetes Service
az aks create --resource-group getting-started-with-microservices-backup --name ak8sbackup --node-count 1 --service-principal d151991c-0676-4878-9985-3b00f562c6b3 --client-secret a0fc54c2-8ee8-4d71-a65e-0242d34dd31d --generate-ssh-keys

## Connecting to the AKS clustes
az aks get-credentials --resource-group getting-started-with-microservices-backup --name ak8sbackup

kubectl get nodes

## Kubectl commands
kubectl apply -f kubernetes\deployment.1.yaml
kubectl get deployments
kubectl apply -f kubernetes\service.1.yaml
kubectl get svc -w
kubectl scale deployment scaffolded-deployment --replicas=2
kubectl delete deployment scaffolded-deployment
kubectl apply -f kubernetes\statefulset.1.yaml
kubectl scale deployment scaffolded-statefulset --replicas=2

#### Navigation:

0. [Readme](README.md)
1. [Prerequisites](01-getting-started-prerequisites.md)
2. [Docker](02-getting-started-docker.md)
3. [Kubernetes](03-getting-started-kubernetes.md)
10. [Commands](10-commands.md)