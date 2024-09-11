// https://learn.microsoft.com/en-gb/training/modules/build-first-bicep-template/4-exercise-define-resources-bicep-template?pivots=powershell

// var uid = sys.uniqueString(resourceGroup().id)

var uid = sys.uniqueString('skye')
var store = 'toystore${uid}'
var app_name = 'toyapp${uid}'
var location = 'australiasoutheast'

// // (broken?) create resoure group when using template at subscription scope 
// // eg: `az deployment create` not `az deployment ~~group~~ create`
// resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//   name: 'bicep-lab'
//   location: location
// }

resource sa 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: store
  location: location
  sku:{
    name:'Standard_LRS'
  }
  kind:'StorageV2'
  properties:{
    accessTier:'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: app_name
    environmentType: 'nonprod'
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
