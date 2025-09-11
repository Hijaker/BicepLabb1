targetScope = 'resourceGroup'

param pName string
param pEnviroment string
param pLocation string
param pStorageSku string
param pKind string
param ptags object
param utc string = utcNow() // Används för att garantera unikt namn, då vissa resources (t.ex. KeyVault) lever kvar i upp till 30 dagar efter deletion

var storageAccountName = '${pEnviroment}${toLower(pName)}${uniqueString(resourceGroup().id, utc)}'



resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name : storageAccountName
  location: pLocation
  sku: {
    name: pStorageSku
  }
  kind: pKind
  tags: ptags
}
