function Reset-APIM {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String] $resourceGroup,
        [Parameter()]
        [String] $apimName,
        [Parameter()]
        [array] $keyVaultNamedValues
    )

    $apimContext = New-AzApiManagementContext -ResourceGroupName $resourceGroup -ServiceName $apimName

    Write-Host "Removing Subscriptions"
    Get-AzApiManagementSubscription -Context $apimContext | Where-Object SubscriptionId -ne "master" | ForEach-Object { Remove-AzApiManagementSubscription -Context $apimContext -SubscriptionId $_.SubscriptionId }

    Write-Host "Removing Products and Product APIs"
    # Remove Product APIs (and products)
    $products = (az apim product list --resource-group $resourceGroup --service-name $apimName --query [].name -o tsv)
    foreach($product in $products)
    {
        $productsApis = (az apim product api list --resource-group $resourceGroup --service-name $apimName --product-id $product --query [].name -o tsv)
        foreach($pa in $productsApis)
        {
            az apim product api delete --resource-group $resourceGroup --service-name $apimName --product-id $product --api-id $pa

        }
        az apim product delete --resource-group $resourceGroup --service-name $apimName --product-id $product --yes
    }

    Write-Host "Removing APIs"
    # Remove APIs
    $apis = (az apim api list --resource-group $resourceGroup --service-name $apimName --query [].name -o tsv)
    foreach($a in $apis)
    {
        az apim api delete --resource-group $resourceGroup --service-name $apimName --api-id $a --yes
    }

    # Remove Backends
    Write-Host "Removing Backends"
    Get-AzApiManagementBackend -Context $apimContext | ForEach-Object { Remove-AzApiManagementBackend -Context $apimContext -BackendId $_.BackendId }

    Write-Host "Removing Diagnostics"
    # Remove Diagnostics
    Get-AzApiManagementDiagnostic -Context $apimContext | ForEach-Object { Remove-AzApiManagementDiagnostic -Context $apimContext -DiagnosticId $_.DiagnosticId }

    Write-Host "Removing Loggers"
    # Remove Loggers
    Get-AzApiManagementLogger -Context $apimContext | ForEach-Object { Remove-AzApiManagementLogger -Context $apimContext -LoggerId $_.LoggerId  }

    Write-Host "Removing Named Values"
    # Remove Named Values
    $nvs = (az apim nv list --resource-group $resourceGroup --service-name $apimName --query [].name -o tsv)
    foreach($n in $nvs)
    {
        az apim nv delete --resource-group $resourceGroup --service-name $apimName --named-value-id $n --yes
    }

    Write-Host "Resetting Global Policy"
    $policy = "<policies>
	<inbound />
	<backend>
		<forward-request />
	</backend>
	<outbound />
	<on-error />
</policies>"
    Set-AzApiManagementPolicy -Context $apimContext -Policy $policy
}
$resourceGroup = "apim-demo"
$targetAPIM = "bootcamp-apim-prod"

Reset-APIM -resourceGroup $resourceGroup -apimName $targetAPIM