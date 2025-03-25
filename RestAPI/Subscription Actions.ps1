#Build common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

#Find your subscription logical zone to physical zone mappings:
$subscriptionid = (Get-AzContext).Subscription.Id
$apiversion = "2024-07-01"
$uri = "https://management.azure.com/subscriptions/$subscriptionid/locations?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -Body $body -ContentType "application/json"
$Result.value | Select-Object name, displayname, availabilityZoneMappings

#Get properties from a Subscription
$subscriptionID = (Get-AzContext).Subscription.Id
$apiversion = "2024-07-01"
$uri = "https://management.azure.com/subscriptions/$($subscriptionID)?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.subscriptionPolicies

#Get roles from a subscription
$subscriptionID = (Get-AzContext).Subscription.Id
$apiversion = "2022-04-01"
$uri = "https://management.azure.com/subscriptions/$($subscriptionID)/providers/Microsoft.Authorization/roleAssignments?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value

#Get role definitions for a subscription
$subscriptionID = (Get-AzContext).Subscription.Id
$apiversion = "2022-04-01"
$uri = "https://management.azure.com/subscriptions/$($subscriptionID)/providers/Microsoft.Authorization/roleDefinitions?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value
