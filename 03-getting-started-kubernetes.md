# Kubernetes - Azure Kubernetes Service (AKS)

## Prerequisites
You have to have existing Azure account, Azure CLI and Docker CE installed on your local machine. 

Next you need created Azure Resource Group and Azure Container Registry, registry must have enabled admin access and you should get an admin password somewhere. 

Furthermore you need a created application with a docker image. Image have to be published to your Azure registry.

Last required thing is installed aks cli.

First few steps are described [here](getting-started-prerequisites.md), the rest of them you are able to find [here](getting-started-docker.md).

## Prepare ACR
Before you can create a cluster, ACR need some preparation. First, you have to create Service Principal which will authenticate in ACR on behalf of new AKS cluster.
`az ad sp create-for-rbac --skip-assignment`
This command will result with output, where you can find fields like `AppId` and `Password`. Save these values somewhere.
Also take a note of ACR object Id:
`az acr show --resource-group <resourceGroupName> --name <acrName> --query "id" --output tsv`
Assign Service Principal to the registry:
`az role assignment create --assignee <appId> --scope <acrId> --role Reader`
Now you are ready to create an AKS cluster.

## Creating an Azure Kubernetes Service
When you decide how large your cluster should be, you can bring it to live with this command:
`az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 1 --service-principal <appId> --client-secret <password> --generate-ssh-keys`
Notice that you are passing Service Principal id and attached password. For me it takes 15 minutes to get cluster up and runing.
Be aware that Azure takes care for creating whole infrastructure for the cluster. Behind the sceen, it creates spcified number of VMs, Network Interfaces etc. These are created in new / different resource group than you specified, unfortunately. 

Please don't bother for now, just keep in mind to remove all resource groups connected with AKS after you finish playing with it.

## Connecting to the cluster
To be able to talk with a cluster, you have to connect with it. It is possible by: 
`az aks get-credentials --resource-group <resourceGroupName> --name <clusterName>`
Later from the command prompt, you can navigate / pass instruction to a cluster with a `kubctl` command.

After a connection was successfully established, type `kubectl get nodes` to list all of you nodes in the cluster. You should see number of nodes exactly same as specified during cluster creation.

## Deploying objects to kubernetes
When everything is set up, you can finally deploy some objects to you cluster. From `kubernetes` directory you can select `deployment.yaml`. This is a file which describe a whole deployment object with set replicas. The command that you are looking for is: `kubectl apply -f <file>.yaml`. 

Check if your application started properly with this command: `kubectl get deployment` - it will show current state of your deployment object. If desire pod number is equal to current one, everything went right. Now, how to get your application? 

It is working somewhere, but without ip address or domain name, you are not able to get output from it. Kubernetes has specific object type which make it possible. Lets deploy it - `service.yaml`. It will take a while, when your service gets a public IP address. The command `kubectl get svc -w` will take services status up to date in your command line. When public IP address shows up, take it and put it hete: `<IPAddress>/api/helloworld`. 

Is it working now? Magic ;)

## Cleanup
###### *If you want to continue with extras, skip this step and go directly there.*
If you remember, I told you that the Azure handles creation infrastructure behind the scen. Now it is a time to clean this up. As in Docker demo case, delete resource group with ACR:
`az group delete --name <resourceGroupName> --yes`
Then, take care about autocreated resource group. Its name should be like this:
`MC_<resourceGroupName>_<clusterName>_westeurope`

## Extras
After made all steps from this specific demo file, I leave my Azure Subscription for a day, again. This time, everything costs a little bit more. For a short demo it takes 20 ¢ (euro cents).

## Extras II
Now think about your persistent data? How to handle it in a microservices manner? How to store it inside a Docker/Kubernetes architecture? There is a way. Until now, we were working on something that called a stateless service. Oposite that, there are stateful services. These are application, that have persistent data stored somewhere. From my experience most common way is to attach a persistent volume to the docker image. On a local machine, you will isolate some operating system disk space with a working container. In a cloud environment, like a Kubernetes on an Azure, you have to provide a disk, or a way that, Kubernetes on its own will do that on your behalf. 

Kubernetes `Statefulsets` besides same attached volume between containers lifetimes, consists of stable and unique network identifiers (inside Kubernetes network) and ordered deployments/scaling/deletion/rolling updates.

Take a look into kubernetes directory again. There should be defined simple stateful set. Remove deployment first and create stateful set from a file. Go to the browser and navigate to you container application. Interesting, huh? 