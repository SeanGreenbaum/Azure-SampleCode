#See authentication code in the previous script

#Build common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

#Check Backup vaults for Immutability settings
$ResourceGRoupName = ""
$vaultname = ""
$subscriptionID = ""
$apiversion = "2023-01-01"
$uri = "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$ResourceGRoupName/providers/Microsoft.DataProtection/BackupVaults/$vaultname/?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.Properties.securitysettings

#Set Immutability settings for a Backup Vault
$ResourceGRoupName = ""
$vaultname = ""
$subscriptionID = ""
$apiversion = "2023-01-01"
$uri = "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$ResourceGRoupName/providers/Microsoft.DataProtection/BackupVaults/$vaultname/?api-version=$apiversion"
$properties = @{
    "securitySettings" = @{
        "immutabilityPeriodSinceCreationInDays" = 30
        "immutabilityPeriodSinceDeletionInDays" = 30
    }
}
$body = @{
    "properties" = $properties
} | ConvertTo-Json
$Result = Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body $body
$Result
