$region = "westeurope"
$resourceGroupName = "getting-started-with-microservices"
$containerRegistryName = "gettingstartedregistry"
$dockerAppName = "getting-started-app"
$containerInstanceName = "gettingstartedinstance"

# Login into azure account
Connect-AzureRmAccount

# Create resource group
New-AzureRmResourceGroup $resourceGroupName $region

## Create a container registry
$registry = New-AzureRMContainerRegistry -ResourceGroupName $resourceGroupName -Name $containerRegistryName -EnableAdminUser -Sku Basic

## Log into the registry
$registryCreds = Get-AzureRmContainerRegistryCredential -Registry $registry
$registryCreds.Password | docker login $registry.LoginServer -u $registryCreds.Username --password-stdin

## Build a docker image
Set-Location ScaffoldedWebApi
docker build -f ScaffoldedWebApi\Dockerfile -t $dockerAppName":latest" .
Set-Location ..

## Tag the docker image with a registry domain
docker tag $dockerAppName":latest" $containerRegistryName".azurecr.io/"$dockerAppName":latest"

## Push an image into registry
docker push $containerRegistryName".azurecr.io/"$dockerAppName":latest"

## Create an Azure container instance
New-AzureRmContainerGroup `
    -ResourceGroupName $resourceGroupName `
    -Name $containerInstanceName `
    -Image $containerRegistryName".azurecr.io/"$dockerAppName":latest" `
    -DnsNameLabel $containerInstanceName `
    -Port 80 `
    -RegistryCredential $registryCreds
