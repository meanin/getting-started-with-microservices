## Create a resource group
`az group create --name getting-started-with-microservices --location westeurope`

## Create a container registry
`az acr create --resource-group getting-started-with-microservices --name gettingstartedregistry --sku Basic`

## Log into the registry
`az acr login --name gettingstartedregistry`

## Build a docker image
`docker build -f ScaffoldedWebApi\Dockerfile -t "getting-started-app:latest" .`

## Tag the docker image with a registry domain
`docker tag getting-started-app:latest gettingstartedregistry.azurecr.io/getting-started-app:latest`

## Push an image into registry
`docker push gettingstartedregistry.azurecr.io/getting-started-app:latest`

## Create an Azure container instance
`az acr update -n gettingstartedregistry --admin-enabled true`

`az acr credential show --name gettingstartedregistry --query "passwords[0].value"`

`az container create --resource-group getting-started-with-microservices --name gettingstartedinstance --image gettingstartedregistry.azurecr.io/getting-started-app:latest --registry-username gettingstartedregistry --registry-password <acrPassword> --dns-name-label getting-started-instace --ports 80`

`http://getting-started-instace.westeurope.azurecontainer.io/api/helloworld`

## Create Service Principal for role base access 
`az ad sp create-for-rbac --skip-assignment`

## Connect RBAC with Registry
`az acr show --resource-group getting-started-with-microservices --name gettingstartedregistry --query "id" --output tsv`

`az role assignment create --assignee <appId> --scope <acrId> --role Reader`

## Create Azure Kubernetes Service
`az aks create --resource-group getting-started-with-microservices --name gettingstartedcluster --node-count 1 --service-principal <appId> --client-secret <password> --generate-ssh-keys`

## Connecting to the AKS clustes
`az aks get-credentials --resource-group getting-started-with-microservices --name gettingstartedcluster`

`kubectl get nodes`

## Kubectl commands
`kubectl apply -f kubernetes\deployment.yaml`
`kubectl get deployments`
`kubectl apply -f kubernetes\service.yaml`
`kubectl get svc -w`
`kubectl scale deployment scaffolded-deployment --replicas=2`

#### Navigation:

0. [Readme](README.md)
1. [Prerequisites](01-getting-started-prerequisites.md)
2. [Docker](02-getting-started-docker.md)
3. [Kubernetes](03-getting-started-kubernetes.md)
...
10. [Commands](10-commands.md)