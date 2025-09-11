# Azure IaC with Bicep

This repository contains Infrastructure as Code (IaC) definitions using [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) for deploying resources into Microsoft Azure.

The setup includes modules for App Service, Web App, Storage Account, and Resource Group (not currently used in the main deployment).

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Deployment Instructions](#deployment-instructions)
  - [Deploy to Development](#deploy-to-development)
  - [Deploy to Test](#deploy-to-test)
  - [Deploy to Production](#deploy-to-production)
  - [Deploy to All Three Envorments](#deploy-to-all-three-envorments)
  - [Outputs](#outputs)
- [Notes](#notes)


---

## Repository Structure

- ```parameters/```
  - ```dev.json``` # Parameters for the Development environment
  - ```test.json``` # Parameters for the Test environment
  - ```prod.json``` # Parameters for the Production environment
- ```src/```
  - ```main.bicep``` # Entry point for the deployment
  - ```modules/```
    - ```appservice.bicep``` # Module for App Service Plan
    - ```webapp.bicep``` # Module for Web App
    - ```storage.bicep``` # Module for Storage Account
    - ```rg.bicep``` # Module for Resource Group (not in use)
   
    
---

## Deployment Instructions

All deployments are performed with the Azure CLI.  
The generic deployment command looks like this:

```bash
az deployment group create -f <deployment-file> --resource-group <your-resource-group> --parameters @parameters/<parameter-file>.json
```

### Deploy to Development
```bash
az deployment group create -f ./src/main.bicep --resource-group <your-resource-group> --parameters @parameters/dev.json
```
### Deploy to Test
```bash
az deployment group create -f ./src/main.bicep --resource-group <your-resource-group> --parameters @parameters/test.json
```

### Deploy to Production
```bash
az deployment group create -f ./src/main.bicep --resource-group <your-resource-group> --parameters @parameters/prod.json
```

### Deploy to All Three Envorments
```powershell
$environments = @("dev", "test", "prod")

foreach ($env in $environments) {
    Write-Output "Deploying to $env..."
    az deployment group create `
      --resource-group <your-resource-group> `
      --template-file ./src/main.bicep `
      --parameters @parameters/$env.json `
      --query "properties.outputs.webAppUrl.value" -o tsv
}
```

```bash
for env in dev test prod
do
  echo "Deploying to $env..."
  az deployment group create \
    --resource-group <your-resource-group> \
    --template-file ./src/main.bicep \
    --parameters @parameters/$env.json \
    --query "properties.outputs.webAppUrl.value" -o tsv
done
```

### Outputs
The Bicep file is configured to output the Web App URL after deployment. To retrieve it, you can query the deployment output directly:
```bash
az deployment group create -f ./src/main.bicep --resource-group <your-resource-group> --parameters @parameters/prod.json --query "properties.outputs.webAppUrl.value" -o tsv
```


## Notes
The ```rg.bicep``` module is included in the repository but is not currently used in the main deployment. Resource group creation is assumed to be handled outside of this deployment. Ensure you are logged into the correct Azure subscription before deploying:
```bash
az login
az account set --subscription <your-subscription-id>
```
