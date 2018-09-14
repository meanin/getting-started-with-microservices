##Create a resource group
`az group create --name getting-started-with-microservices --location westeurope`

##Create a container registry
`az acr create --resource-group getting-started-with-microservices --name gettingstartedregistry --sku Basic`

##Log into the registry
`az acr login --name gettingstartedregistry `

##Build a docker image
`docker build -f ScaffoldedWebApi\Dockerfile -t "getting-started-app:latest" .`

##Tag the docker image with a registry domain
`docker tag getting-started-app:latest gettingstartedregistry.azurecr.io/getting-started-app:latest`

##Push an image into registry
`docker push gettingstartedregistry.azurecr.io/getting-started-app:latest`

##Create an Azure container instance
`az acr update -n gettingstartedregistry --admin-enabled true`

`az acr credential show --name gettingstartedregistry --query "passwords[0].value"`

`az container create --resource-group getting-started-with-microservices --name gettingstartedinstance --image gettingstartedregistry.azurecr.io/getting-started-app:latest --registry-username gettingstartedregistry --registry-password <acrPassword> --dns-name-label getting-started-instace --ports 80`

`http://getting-started-instace.westeurope.azurecontainer.io/api/helloworld`
