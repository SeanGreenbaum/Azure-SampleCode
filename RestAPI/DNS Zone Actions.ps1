#See authentication code in the previous script

#Build common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

#Get all records in a public DNS Zone
$subscriptionid = (Get-AzContext).Subscription.Id
$ResourceGRoupName = ""
$zonename = ""
$apiversion = "2018-05-01"
$Result = Invoke-RestMethod -Method Get -Uri "https://management.azure.com/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/dnsZones/$zonename/all?api-version=$apiversion" -Headers $headers
$Result.value | Format-Table Name, type, properties

#Get all records in a private DNS Zone
$subscriptionid = (Get-AzContext).Subscription.Id
$ResourceGRoupName = ""
$zonename = ""
$apiversion = "2018-05-01"
$Result = Invoke-RestMethod -Method Get -Uri "https://management.azure.com/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/privateDnsZones/$zonename/all?api-version=$apiversion" -Headers $headers
$Result.value | Format-Table Name, type, properties
$Result.value | ConvertTo-Json -Depth 5 | Out-File c:\windows\temp\DNSExport.json
