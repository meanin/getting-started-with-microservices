# Docker - Azure Container Instance (ACI)

## Azure container registry

Again as a first step, create a registry (private) for your docker application. From here you will be able to pull your application images and create a working containers.

Here is a simple command to create an Azure container registry:
`az acr create --resource-group <resourceGroupName> --name <acrName> --sku Basic`

After registry creation is done, you can log into your registry with a Azure CLI:
`az acr login --name <acrName>`

Try to get a list of all your images:
`az acr repository list --name <acrName> --output table`
Nothing there, are you surprised?

## Create a simple application
Open your VisualStudio, start new .net core project and select WebApi with Docker support enabled. Build your newly created app and try to debug it!

Yay, it works!

## Create an image from a source code
Navigate to the solution directory. Build your docker image with a command:
`docker build -f <dockerProjectDirectory>\Dockerfile -t "<dockerImageName>:latest" .`

## Publish an application into a registry
Before you can push an image to the registry, you have to tag it with a registry name. Type a following command:
`docker tag <dockerImageName>:latest <acrName>.azurecr.io/<dockerImageName>:latest`
Then you are able to push you application image to your own registry, follow this command:`docker push <acrName>.azurecr.io/<dockerImageName>:latest`

## Create an Azure container instance
First of all you have to enable admin access to a container registry, with the following command:
`az acr update -n <acrName> --admin-enabled true`
Then you have to get a password for an admin access:
`az acr credential show --name <acrName> --query "passwords[0].value"`
Now you have all informations that you need to start you first container instance, but now a command will be a little bit long:
`az container create --resource-group <resourceGroupName> --name <aciName> --image <acrName>.azurecr.io/<dockerImageName>:latest --registry-username <acrName> --registry-password <acrPassword> --dns-name-label <aciDnsName> --ports 80`
Navigate from your browser to the:`http://<aciDnsName>.westeurope.azurecontainer.io/api/helloworld` and voila`.

## Cleanup
###### *If you want to continue with Kubernetes demo, skip this step and go directly to the next document.*
If you want to free your resource and maybe more important reduce costs, you have to remove all components that you created during this demo. Be brave it can take a while. It is possible by this command:
`az group delete --name <resourceGroupName> --yes`

## Extras
After made all steps from this specific demo file, I leave my Azure Subscription for a day (Azure costs are calculated daily). Next day, I checked bill and I was surprised, because this whole play cost me exatcly 3 ¢ (euro cents) :)

#### Navigation:

0. [Readme](README.md)
1. [Prerequisites](01-getting-started-prerequisites.md)
2. [Docker](02-getting-started-docker.md)
3. [Kubernetes](03-getting-started-kubernetes.md)
...
10. [Commands](10-commands.md)