$resourceGroup = "apim-demo"
$targetAPIM = "bootcamp-apim-prod"

az deployment group create -g $resourceGroup --template-file "..\templates\base-tags.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-products.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-namedValues.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-backends.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-globalServicePolicy.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-loggers.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-apis.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-apiTags.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\base-productApis.template.json" --parameters ApimServiceName=$targetAPIM