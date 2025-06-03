#See authentication code in the previous script

#Build common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

#List all VMs in a given subscription
$subscriptionid = (Get-AzContext).Subscription.Id
$apiVersion = "2024-11-01"
$uri = "https://management.azure.com/subscriptions/$subscriptionid/providers/Microsoft.Compute/virtualMachines?api-version=$apiVersion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value | Format-Table Name, location

#List all VMs in a given Resource Group
$resourcegroup = ""
$apiVersion = "2024-11-01"
$subscriptionid = (Get-AzContext).Subscription.Id
$uri = "https://management.azure.com/subscriptions/$subscriptionid/resourceGroups/$resourcegroup/providers/Microsoft.Compute/virtualMachines?api-version=$apiVersion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value | Format-Table Name, location

#Start a VM
$subscriptionid = (Get-AzContext).Subscription.Id
$ResourceGRoupName = ""
$VMName = ""
$apiversion = "2024-11-01"
$uri = "https://management.azure.com/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName/start?api-version=$apiversion"
Invoke-RestMethod -Method Post -Uri $uri -Headers $headers

#Stop a VM
$subscriptionid = (Get-AzContext).Subscription.Id
$ResourceGRoupName = ""
$VMName = ""
$apiversion = "2024-11-01"
$uri = "https://management.azure.com/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName/deallocate?api-version=$apiversion"
Invoke-RestMethod -Method Post -Uri $uri -Headers $headers

