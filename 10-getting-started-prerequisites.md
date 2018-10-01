# Prerequisites

First of all, we need installed Azure CLI. You can download it [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest). After short installation guide, you will be able to run `az-commands` from command line.

To check if everything is working correctly, under command line, type `az login`. It should open your default browser on a page https://login.microsoftonline.com/. Type there your login and password. Now you can close the browser.

## Azure account
If you do not have an azure account yet, you can start for free [here](https://azure.microsoft.com/en-us/free/). After pin your credit card, you will be rewarded with a €170 credit for a 30 days exploration.

## Test Resource Group
Azure resource group is an object which does not cost you anything. Its only purpose is to group all your components into logic part. You can instantiate a group with the following command:
`az group create --name myResourceGroup --location eastus`

## Docker CE
For this demo, Docker Community Edition is a must have. You can download it from [here](https://www.docker.com/get-started). To be able to build and run a linux images, you have to enable virtualization and have a hyper-v support. You can install docker only on a machine with a hyper-v, so Windows 10 Pro i.e.

## Azure CLI AKS
To be able to communicate with a kubernetes cluster in azure, you have to install cli. It is possible by running this command: `az aks install-cli` on a machine with an Azure CLI installed previously.

#### Navigation:

0. [Readme](README.md)
1. [Prerequisites](01-getting-started-prerequisites.md)
2. [Docker](02-getting-started-docker.md)
3. [Kubernetes](03-getting-started-kubernetes.md)
10. [Commands](10-commands.md)