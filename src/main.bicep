targetScope = 'resourceGroup'

param pName string
param pLocation string
param pEnviroment string
param pSkuName string
param pCapacity int

param pHttpsOnly bool
param pKind string
param pStorageSku string

param pTagOwner string
param pTagCostCenterDepartment string

//var resourceGroupName = 'rg-${pName}-${pEnviroment}'

var tags = {
  owner: pTagOwner
  enviroment: pEnviroment
  costCenter: pTagCostCenterDepartment
}

/*module rg 'modules/rg.bicep' = {
  name: 'resourceGroup'
  params: {
    pName: resourceGroupName
    pEnviroment: pEnviroment
    pLocation: pLocation
    pTags: tags
  }
}*/


module storageAccount 'modules/storage.bicep' = {
  name: '${pEnviroment}${pName}StorageAccount'
  //scope: resourceGroup(resourceGroupName)
  params: {
    pName: pName
    pEnviroment: pEnviroment
    pKind: pKind
    pLocation: pLocation
    pStorageSku: pStorageSku
    ptags: tags
  }
}

module appServicePlan 'modules/appservice.bicep' = {
  name: '${pEnviroment}${pName}AppServicePlan'
  //scope: resourceGroup(resourceGroupName)
  params: {
    pName: pName
    pLocation: pLocation
    pEnviroment: pEnviroment
    pCapacity: pCapacity
    pSku: pSkuName
    pTags: tags
  }
}

module webApp 'modules/webapp.bicep' = {
  name: '${pEnviroment}${pName}WebApp'
  //scope: resourceGroup(resourceGroupName)
  params:{
    pName: pName
    pEnviroment: pEnviroment
    pLocation: pLocation
    pHttpsOnly: pHttpsOnly
    pServerFarmId: appServicePlan.outputs.appServicePlanId
    pTags: tags
  }
}

output webAppUrl string = 'https://${webApp.outputs.websiteName}.azurewebsites.net'
