$resourceGroup = "apim-demo"
$targetAPIM = "bootcamp-apim-prod"

az deployment group create -g $resourceGroup --template-file "..\templates\bootcamp-apim-prod-tags.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\bootcamp-apim-prod-products.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\bootcamp-apim-prod-namedValues.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\bootcamp-apim-prod-backends.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\dad-joke.api.template.json" --parameters ApimServiceName=$targetAPIM

az deployment group create -g $resourceGroup --template-file "..\templates\bootcamp-apim-prod-productApis.template.json" --parameters ApimServiceName=$targetAPIM