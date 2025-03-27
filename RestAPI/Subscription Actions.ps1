#Build common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

$managementURL = "management.azure.com/" #Azure public Cloud
$managementURL = "management.usgovcloudapi.net/" #Azure US Gov Cloud

#Find your subscription logical zone to physical zone mappings:
$subscriptionid = (Get-AzContext).Subscription.Id
$apiversion = "2024-07-01"
$uri = "https://$managementURL/subscriptions/$subscriptionid/locations?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -Body $body -ContentType "application/json"
$Result.value | Select-Object name, displayname, availabilityZoneMappings

#Loop through multuple subscriptions and get the logical zone to physical zone mappings:
$apiversion = "2024-07-01"
$region = ""
$subscriptions = @(
    "guid1"
    "guid2"
    "guid3"
)
$AllResults = @()
ForEach ($Sub in $subscriptions) {
    $uri = "https://$managementURL/subscriptions/$Sub/locations?api-version=$apiversion"
    $Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -Body $body -ContentType "application/json"
    $AllResults += $Result.value | Where-Object {$_.name -eq $region} | Select-Object id, name, displayname, availabilityZoneMappings
}
$AllResults | Out-String -Width 1000000 | Out-File .\zonemappings.txt



#Get properties from a Subscription
$subscriptionID = (Get-AzContext).Subscription.Id
$apiversion = "2024-07-01"
$uri = "https://$managementURL/subscriptions/$($subscriptionID)?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.subscriptionPolicies

#Get roles from a subscription
$subscriptionID = (Get-AzContext).Subscription.Id
$apiversion = "2022-04-01"
$uri = "https://$managementURL/subscriptions/$($subscriptionID)/providers/Microsoft.Authorization/roleAssignments?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value

#Get role definitions for a subscription
$subscriptionID = (Get-AzContext).Subscription.Id
$apiversion = "2022-04-01"
$uri = "https://$managementURL/subscriptions/$($subscriptionID)/providers/Microsoft.Authorization/roleDefinitions?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value
