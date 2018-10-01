$region = "westeurope"
$resourceGroupName = "getting-started-with-microservices"
$containerRegistryName = "gettingstartedregistry"
$dockerAppName = "getting-started-app"
$kubernetesServiceName = "gettingstartedcluster"

# Login into azure account
Connect-AzureRmAccount

# Create resource group
New-AzureRmResourceGroup $resourceGroupName $region

# Create a container registry
$registry = New-AzureRMContainerRegistry -ResourceGroupName $resourceGroupName -Name $containerRegistryName -EnableAdminUser -Sku Basic
$registry = Get-AzureRmContainerRegistry -ResourceGroupName $resourceGroupName -Name $containerRegistryName

## Log into the registry
$registryCreds = Get-AzureRmContainerRegistryCredential -Registry $registry
$registryCreds.Password | docker login $registry.LoginServer -u $registryCreds.Username --password-stdin

# Build a docker image
Set-Location ScaffoldedWebApi
docker build -f ScaffoldedWebApi\Dockerfile -t $dockerAppName":latest" .
Set-Location ..

# Tag the docker image with a registry domain
docker tag $dockerAppName":latest" $containerRegistryName".azurecr.io/"$dockerAppName":latest"

# Push an image into registry
docker push $containerRegistryName".azurecr.io/"$dockerAppName":latest"

# Create Service Principal for role base access 
# Connect RBAC with Registry
$SecureStringPassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
$servicePrincipal = New-AzureRmADServicePrincipal -Role Reader -Scope $registry.Id -Password $SecureStringPassword
$spCreds = New-Object System.Management.Automation.PSCredential ($servicePrincipal.Id, $SecureStringPassword)

# Install module for managing AKS
# If you do not have installed this module uncomment line below and execute with admin permitions
# Install-Module -Name AzureRM.Aks -AllowPrerelease

# Create Azure Kubernetes Service
# https://github.com/Azure/azure-powershell/issues/7436
New-AzureRmAks -ResourceGroupName $resourceGroupName -Name $kubernetesServiceName -ClientIdAndSecret $spCreds -Location $region -NodeCount 1 

# Connecting to the AKS clustes
Import-AzureRmAksCredential -ResourceGroupName $resourceGroupName -Name $kubernetesServiceName

kubectl get nodes

# Kubectl commands
kubectl apply -f kubernetes\deployment.yaml
kubectl get deployments
kubectl apply -f kubernetes\service.yaml
kubectl get svc